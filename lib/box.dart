import 'package:path_provider/path_provider.dart';
import 'package:objectbox/objectbox.dart';
import 'package:play_with_object_box/entity.dart';
import 'package:play_with_object_box/objectbox.g.dart';
import 'package:path/path.dart' as path;

class ObjectBox {
  late final Store _store;
  late final Box<Produto> _productBox;

  ObjectBox._create(this._store) {
    _productBox = Box<Produto>(_store);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore(
      directory: path.join(
          (await getApplicationDocumentsDirectory()).path, 'obx-product'),
    );
    return ObjectBox._create(store);
  }

 Future<void> closeStore() async {
    _store.close();
  }

  void _putDemoData() {
    final demoNotes = [
      Produto(name: 'Produto1', country: 'Brazil', productId: 1),
      Produto(name: 'Produto2', country: 'Portugal', productId: 2),
      Produto(name: 'Produto3', country: 'Espanha', productId: 3),
    ];
    _productBox.putManyAsync(demoNotes);
  }

  List<Produto> getProducts() {
    final productList = _productBox.getAll();

    return productList;
  }

  Future<void> addProducts(List<Produto> products) =>
      _productBox.putManyAsync(products);

  Future<void> addProduct(Produto product) async {
    await _productBox.putAsync(product);
    getProducts();
  }

  Future<void> removeAll() async {
    _productBox.removeAll();
  }

  Future<void> remove(int id) async{
    _productBox.remove(id);
  }
}
