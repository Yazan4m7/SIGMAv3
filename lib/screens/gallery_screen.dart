import 'package:app/widgets/gallery_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final remoteServices = Get.find<RemoteServicesController>();


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: kWhite,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text("GALLERY"),
        ),
        body: Container(
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundPath),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [

                Expanded(
                  //height: MediaQuery.of(context).size.height,
                  child:
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: remoteServices.galleryMedia.length,
                      itemBuilder: (context, index) {
                        return GalleryMediaTile(galleryMedia: remoteServices.galleryMedia[index]);
                      },
                    ),

                ),
              ],
            ),
          ),
        ));
  }
}
