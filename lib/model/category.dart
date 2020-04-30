class Category {
  final String name;
  final int numOfCourses;
  final String image;

  Category(this.name, this.numOfCourses, this.image);
}

List<Category> categories = categoriesData
    .map((item) => Category(item['name'], item['courses'], item['image']))
    .toList();

var categoriesData = [
  {"name": "Marketing", 'courses': 17, 'image': "assets/temp/marketing.png"},
  {"name": "UX Design", 'courses': 25, 'image': "assets/temp/ux_design.png"},
  {
    "name": "Photography",
    'courses': 13,
    'image': "assets/temp/photography.png"
  },
  {"name": "Business", 'courses': 17, 'image': "assets/temp/business.png"},
];
