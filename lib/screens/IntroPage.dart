import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'CreateAccountOrLogin.dart';

class IntroPage extends StatefulWidget {

  static const String id = 'IntroPage';

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin{

  //here: creating our ANIMATION CONTROLLER:
  AnimationController controller;

  //here: creating an ANIMATION variable:
  Animation animation;

  //also needed: overriding the INITSTATE() method:
  @override
  void initState() {

    final player = AudioCache();
    player.play('intro_whoosh.wav');
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 990),
      //this property acts as the ticker (and implicates the _WelcomeScreenState object with THIS):
      vsync: this,
      //upperBound: 500
    );

    //here: initialising our ANIMATION-type variable: to become a CURVEANIMATION object:
    animation = CurvedAnimation(

      //here: defining what animation controller we wish to apply this special curve effect to
        parent: controller,

        //here: the specific curve effect we wish to implement (chosen from the CURVE doc):
        curve: Curves.easeInQuint
    );

    //this proceeds our animation forwards!
    controller.forward();

    //to ***see* what our controller is doing, we need to add a LISTENER:
    //(+ adding an empty SETSTATE() into our listener, to make the background colour change happen!)
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: Colors.black,

        body: Column(

            children: <Widget>[

              Expanded(
                child: SizedBox(
                  height: 10.0,
                ),
              ),

              FadeIn(
                child: Container(
                  child: Image(
                    image: AssetImage('images/KKG_logo.PNG'),
                    height: animation.value * 500
                  ),
                ),
              ),

              Expanded(

                child: Container(

                  padding: EdgeInsets.only(top: 80.0),

                  child: FadeIn(

                    child: Center(

                      child: RaisedButton(

                        onPressed: () {

                          final player = AudioCache();
                          player.play('enter.flac');

                          Navigator.pushNamed(context, CreateAccountOrLogin.id);

                        },

                        textColor: Color(0xFFDB3654),
                        padding: EdgeInsets.all(0.0),

                        child: Container(

                          decoration: BoxDecoration(
                              color: Colors.black
                          ),

                          padding: EdgeInsets.all(10.0),

                          child:
                            const Text(
                              'Let\'s trade...',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic)
                          ),

                        ),
                      ),
                    ),


                    duration: Duration(milliseconds: 9000),
                    curve: Curves.easeIn,

                  ),
                ),
              ),
            ]
        )
    );
  }
}
