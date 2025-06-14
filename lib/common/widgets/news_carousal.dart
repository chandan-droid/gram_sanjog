import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:gram_sanjog/common/theme/theme.dart";
import "package:gram_sanjog/controller/top_news_controller.dart";
import "../../model/news_model.dart";
import "../../model/top_news_model.dart";
import "../../view/detailed_news_view.dart";



class TopNewsCarousel extends StatefulWidget{

   const TopNewsCarousel({super.key});

    @override
    State<StatefulWidget> createState() {
        return _NewsCarouselState();
    }
}

class _NewsCarouselState extends State<TopNewsCarousel>{

  final topNewsController = Get.put(TopNewsController());
  final PageController pageController = PageController(viewportFraction: 0.9,initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       SizedBox(
         height: 230,
         child: Obx((){
           if (topNewsController.isLoading.value) {
             return const Center(child: CircularProgressIndicator());
           }
           if (topNewsController.topNewsList.isEmpty) {
             return  SizedBox(
               height: 230,
               child: Center(child: Text(topNewsController.errorMessage.value)),
             );
           }
           return PageView.builder(
               controller: pageController,
               itemCount: topNewsController.topNewsList.length,
               onPageChanged: (index){
                 setState(() {
                   currentPage = index;
                 });
               },
               itemBuilder:(context,index){

                 final news = topNewsController.topNewsList[index];
                 final imageUrl = (news.imageUrls.isNotEmpty) ? news.imageUrls[0] : '';
                 return GestureDetector(
                   onTap: (){
                     Get.to(NewsDetailScreen(newsId:news.newsId,));
                   },
                   child: AnimatedContainer(
                     duration:const Duration(milliseconds: 300),
                     margin: EdgeInsets.symmetric(horizontal: 8, vertical: index == currentPage ? 4 : 12),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(16),
                       boxShadow: [
                         BoxShadow(
                           color: Theme.of(context).shadowColor.withOpacity(0.1),
                           blurRadius: 6,
                           offset: const Offset(0, 4),
                         ),
                       ],
                       color: Theme.of(context).cardColor,
                     ),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(10),
                       child: Stack(
                         fit: StackFit.expand,
                         children: [
                           Image.network(
                             imageUrl,
                             fit: BoxFit.cover,
                             errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                           ),
                           Container(
                             decoration: BoxDecoration(
                               gradient: LinearGradient(
                                 colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                                 begin: Alignment.bottomCenter,
                                 end: Alignment.topCenter,
                               ),
                             ),
                           ),
                           Positioned(
                             bottom: 12,
                             left: 12,
                             right: 12,
                             child: Text(news.title,
                               style: appTheme.textTheme.headlineMedium?.copyWith(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold,
                               ),
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                             ),
                           )
                         ],
                       ),
                     ),
                   ),
                 );
               });
         })
       ),
       const SizedBox(height: 10,),
       Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: List.generate(
             topNewsController.topNewsList.length, //length
             (index){ //generator
                return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 15 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? appTheme.primaryColor
                        : appTheme.primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
             }
             )
       )
     ],
   );
  }
}
