class CurrentUser {
    static int id;
    static String userId;
    static String name;
    static String age;
    static String password;
    static String quote;

    static String whoCurrent(){
      return "current -> _id: $id, userid: ${userId}, name: ${name}, age: ${age}, password: ${password}, quote: ${quote}";
   }
}