import 'package:flutter/material.dart';

class Stars extends StatelessWidget {
  const Stars({Key? key, required this.nbStars}) : super(key: key);
final int nbStars;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 70,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
          return index<nbStars? Icon(Icons.star,color: Colors.amber[600],):Icon(Icons.star_border);
        }),
    );
    
  }
}