import 'package:demo/firebase_helper.dart';
import 'package:demo/theme/customColors.dart';
import 'package:flutter/material.dart';


class EditEvent extends StatefulWidget {
  String eventName;
  String docId;
  EditEvent({Key? key,required this.eventName,required this.docId}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  TextEditingController _eventName=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _eventName.text=widget.eventName;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: ()=>Navigator.pop(context),
            child:const Icon(Icons.arrow_back,color: Colors.black,)),
        backgroundColor: Colors.white,
        title:const Text("AddNewEventScreen",style: CustomColors.customBlackStyle,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Center(child: Text("Name"))),
                Expanded(
                  child: Center(
                    child: TextFormField(
                      controller: _eventName,
                      decoration:const InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder()
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40,),
            ElevatedButton(onPressed: ()async{
              if(widget.eventName==""){
                var response=await FirebaseCloud.addEmployee(eventName: _eventName.text);
                if(response.code==200){
                  debugPrint("Date Added to cloud");
                }else{
                  debugPrint("Error in Inserting the data");
                }
              }else{
                var response=await FirebaseCloud.updateEmployee(eventName: _eventName.text, docId: widget.docId);
                if(response.code==200){
                  debugPrint("Date Updated to cloud");
                }else{
                  debugPrint("Error in updating the data");
                }
              }
            }, child:Text("Save",style: CustomColors.customRedStyle,),style: ElevatedButton.styleFrom(
                primary: Colors.black
            ),)
          ],
        ),
      ),
    );
  }
}