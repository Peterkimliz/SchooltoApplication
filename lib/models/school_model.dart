class SchoolModel{
   String ?email;
   String? name;
   String ?id;
   SchoolModel({this.id,this.email,this.name});


   factory SchoolModel.fromJson(Map<String,dynamic>json)=>SchoolModel(
     id: json["id"],
     name: json["name"],
     email: json["email"],
   );
}