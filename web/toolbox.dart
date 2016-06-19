part of shooter;

class Keyboard {
   final HashSet<int> _keys = new HashSet<int>();

   Keyboard() {
      window.onKeyDown.listen((final KeyboardEvent e) {
         _keys.add(e.keyCode);
      });

      window.onKeyUp.listen((final KeyboardEvent e) {
         _keys.remove(e.keyCode);
      });
   }

   isPressed(int keyCode) => _keys.contains(keyCode);
}

class JSONRequest {
   String _prefix = "assets/";
   String _file;
   JsonObject  _jsonObject;

   JSONRequest(this._file) {
      var req = new HttpRequest();
      req.onLoad.listen((e) => _onDataLoaded(req.responseText));
      req.open('GET', _prefix + _file, async: false);
      req.send();
   }

   void _onDataLoaded(String responseText) {
      _jsonObject = new JsonObject.fromJsonString(responseText);
   }

   Object get(String key) {
      if (_jsonObject.containsKey(key)) {
         return _jsonObject[key];
      }
      print("No key '" + key + "' found in file '"+ _file + "'");
      return null;
   }

   bool hasKey(String key){
      return _jsonObject.containsKey(key);
   }
}

class TextUtil {
   void _initContext(CanvasRenderingContext2D context) {
      context..fillStyle = '#fff'
      ..font = "20pt squares";
   }

   void _addShaddow(CanvasRenderingContext2D context) {
      context..shadowOffsetX = 2
      ..shadowOffsetY = 2
      ..shadowBlur = 0
      ..shadowColor = 'rgba(75, 75, 75,  0.8)';
   }

   void _removeShaddow(CanvasRenderingContext2D context) {
      context..shadowOffsetX = 0
      ..shadowOffsetY = 0
      ..shadowBlur = 0
      ..shadowColor = 'rgba(255, 255, 255,  1)';
   }

   void drawString(CanvasRenderingContext2D context, String text, int x, int y) {
      _initContext(context);
      _addShaddow(context);
      context.fillText(text, x, y);
      _removeShaddow(context);
   }

   void drawCenteredString(CanvasRenderingContext2D context, String text, int x, int y) {
      drawStringAligned(context, text, x, y, "center");
   }

   void drawStringAligned(CanvasRenderingContext2D context, String text, int x, int y, String align) {
      context.textAlign = align;
      drawString(context, text, x, y);
      context.textAlign = "left";
   }

   void drawStringFloatRight(CanvasRenderingContext2D context, String text, int x, int y) {
      _initContext(context);
      drawString(context, text, x - context.measureText(text).width, y);
   }

   void wrapText(context, text, x, y, maxWidth, lineHeight) {
      _initContext(context);
      var words = text.split(" ");
      var line = "";
      for(var n = 0; n < words.length; n++) {
         var testLine = '${line}${words[n]} ';
         var metrics = context.measureText(testLine);
         var testWidth = metrics.width;
         if(testWidth > maxWidth) {
            context.fillText(line, x, y);
            line = '${words[n]} ';
            y += lineHeight;
         }
         else { line = testLine; }
      }
      context.fillText(line, x, y);
   }
}
