import 'package:flutter/material.dart';

class FullScreenLoader2 extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final bool isList;
  final String title;
  final List<Widget> actions;

  const FullScreenLoader2(
      {super.key,
      required this.isLoading,
      required this.child,
      required this.isList,
      required this.title,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isLoading == false
            ? Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (isList == true) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop(true);
                      }
                    },
                  ),
                  actions: actions,
                  iconTheme: const IconThemeData(color: Colors.white),
                  centerTitle: true,
                  title: Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color.fromRGBO(32, 76, 56, 1),
                ),
                backgroundColor: const Color.fromRGBO(103, 122, 105, 1),
                body: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(10),
                    color: const Color.fromRGBO(235, 241, 224, 1),
                    child: child),
              )
            : Container(
                color: const Color.fromRGBO(32, 76, 56, 1),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Good things come to those who wait!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              color: Colors.black,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
