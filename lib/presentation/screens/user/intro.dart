part of '../screens.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool isRandomImageBannerVisible = true;

  @override
  Widget build(BuildContext context) {
    var storage;
    var formattingProvider;

    double screenWidth = getSize(context).width;
    double screenHeight = getSize(context).height;

    return Scaffold(
      body: Ink(
        width: screenWidth,
        height: screenHeight,
        decoration: kDecorBackground,
        child: Column(
          children: [
            const FractionallySizedBox(
              widthFactor: 1.0, // Take the full width
              child: IntroVideo(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02, // 2% of the screen width
                  vertical: screenHeight * 0.015, // 1.5% of the screen height
                ),
                child: Column(
                  children: [
                    Text(
                      "www.oohlivetv.com",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04, // 4% of the screen width
                      ),
                    ),
                    SizedBox(
                        height: screenHeight * 0.01), // 1% of the screen height
                    Text(
                      "Enjoy watching your favorite \nwherever and whenever you like"
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize:
                            screenWidth * 0.025, // 2.5% of the screen width
                      ),
                    ),
                    const Spacer(),
                    CardTallButton(
                      label: "Add User",
                      onTap: () => Get.toNamed(screenRegister),
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.005), // 0.5% of the screen height
                    ElevatedButton(
                      onPressed: () => Get.toNamed(
                        '/channel-list',
                        arguments: {
                          'context': context,
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 12, 12, 12),
                        backgroundColor:
                            const Color.fromARGB(255, 241, 240, 240),
                      ),
                      child: const Text("FREE CHANNELS"),
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.005), // 0.5% of the screen height
                    ElevatedButton(
                      onPressed: () {
                        // Handle link tap
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        "oohlivetv.net",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
