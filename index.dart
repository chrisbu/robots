import 'dart:html';
import '../lib/mars_landing.dart';

main() {
  query("#run").onClick.listen((e) {
    var input = query("#input").value;
    var result = "";
    try {
      result = landOnMars(input);

      if (result.length == 0) {
        result = "Ran successfully, but there was no output. Perhaps you forgot the robots?";
      }
    }
    catch (ex) {
      result = ex.toString();
    }


    query("#output").innerHtml = result;
  });

  query("#clearInput").onClick.listen((e) {
    query("#input").value= "";
  });

  query("#clearOutput").onClick.listen((e) {
    query("#output").innerHtml = "";
  });

}