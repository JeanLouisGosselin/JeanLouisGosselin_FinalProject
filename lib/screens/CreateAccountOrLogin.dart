import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'LoginScreen.dart';
import 'CreateAccountScreen.dart';
import '../reusables/MainAppBarDesign.dart';
import '../buttons/IntroButton.dart';


class CreateAccountOrLogin extends StatelessWidget {

  static const String id = 'CreateAccountOrLogin_Screen';

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: MainAppBarDesign(),

      body: Center(

        child: Container(

          child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[

                ////////////////////////////////////////////////////

                IntroButton(
                    title: 'Create account',
                    thisColor: Colors.amber,
                    minimumWidth: 300.0,
                    thisFunc: (){
                      final player = AudioCache();
                      player.play('tick.wav');
                      Navigator.pushNamed(context, CreateAccountScreen.id);
                    }
                ),

                ////////////////////////////////////////////////////

                SizedBox(
                  height: 30.0,
                ),

                ////////////////////////////////////////////////////

                IntroButton(
                    title: 'Login',
                    thisColor: Colors.amber,
                    minimumWidth: 300.0,
                    thisFunc: (){
                      final player = AudioCache();
                      player.play('tick.wav');
                      Navigator.pushNamed(context, LoginScreen.id);
                    }
                ),
              ],
          ),
        ),
      ),
    );
  }
}