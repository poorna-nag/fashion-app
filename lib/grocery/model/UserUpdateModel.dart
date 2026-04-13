
class U_updateModal{

  String success;
  String message;
  String img;

  @override
  String toString() {
    return 'U_updateModal{success: $success, message: $message,img: $img}';
  }
  
  U_updateModal(
      this.success,
      this.message,
      this.img,);

  factory U_updateModal.fromJson(dynamic json) {
    return U_updateModal(
      json['success']?.toString() ?? 'false', 
      json['message']?.toString() ?? 'No message', 
      json['img']?.toString() ?? ''
    );
  }
}