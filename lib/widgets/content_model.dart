class OnboardingContent{
  String image;
  String title;
  String description;
  OnboardingContent({
   required this.image,
   required this.title,
   required this.description,
});
}
List<OnboardingContent> contents =[
  OnboardingContent(
      image: 'lib/images/screen1.png',
      title: 'Select from our\n   Best Menu',
      description: 'Pick your food from our menu\n    More than 35 times'
  ),
  OnboardingContent(
      image: 'lib/images/screen2.png',
      title: 'Easy and Online payment',
      description: 'You can pay cash on delivery and\n     Card payment is available'
  ),
  OnboardingContent(
      image: 'lib/images/screen3.png',
      title: 'Quick Delivery at Your Doorstep',
      description: 'Deliver your food at your\n     Doorstep'
  ),
];