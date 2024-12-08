import 'package:news_app/model/new_model.dart';

List<CategoryModel> getCategories(){ 

  List<CategoryModel> categories = [] ;

  CategoryModel catergory = CategoryModel();
  catergory.categoryName = "Science";

  categories.add(catergory); 

  catergory = CategoryModel();
  catergory.categoryName = "Sports";

  categories.add(catergory);

  catergory = CategoryModel();
  catergory.categoryName = "Business";

  categories.add(catergory);

  catergory = CategoryModel();
  catergory.categoryName = "General";

  categories.add(catergory);

  catergory = CategoryModel();
  catergory.categoryName = "Health";

  categories.add(catergory);

  catergory = CategoryModel();
  catergory.categoryName = "Entertainment";

  categories.add(catergory);

  return categories;
}