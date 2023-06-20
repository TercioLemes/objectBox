import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:play_with_object_box/box.dart';
import 'package:play_with_object_box/entity.dart';
import 'package:play_with_object_box/objectbox.g.dart';

late ObjectBox objectbox;
final streamList = StreamController<bool>();

Stream<bool> get listStream => streamList.stream;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(
    const MaterialApp(home: MyObjectBoxApp()),
  );
}

class MyObjectBoxApp extends StatefulWidget {
  const MyObjectBoxApp({Key? key}) : super(key: key);

  @override
  State<MyObjectBoxApp> createState() => _MyObjectBoxAppState();
}

class _MyObjectBoxAppState extends State<MyObjectBoxApp> {
  int productIdInBox = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Box App'),
        leading: ElevatedButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await objectbox.closeStore();

            await compute(
              outraThread,
              Produto(
                name: 'ProdutoNEW',
                country: 'Brazil',
                productId: 001,
              ),
            );
            objectbox = await ObjectBox.create();
            streamList.sink.add(true);
          },
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                await objectbox.remove(productIdInBox);
                streamList.sink.add(true);
              },
              child: const Icon(Icons.remove))
        ],
      ),
      backgroundColor: Colors.blue,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<bool>(
          stream: listStream,
          builder: (context, snapshot) {
            final dados = objectbox.getProducts();
            if (dados.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
            }

            return ListView.builder(
              itemCount: dados.length,
              itemBuilder: (context, index) {
                if (dados.length == index + 1) {
                  productIdInBox = dados.last.id;
                }
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 40,
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Text(dados[index].name),
                        const SizedBox(height: 4),
                        Text(dados[index].country),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

void outraThread(Produto product) {
  final store = Store(getObjectBoxModel(),
      directory:
          '/data/user/0/com.example.play_with_object_box/app_flutter/obx-product');
  final box = Box<Produto>(store);

  store.runInTransaction(
    TxMode.write,
    () => box.put(product),
  );
  store.close();
}
