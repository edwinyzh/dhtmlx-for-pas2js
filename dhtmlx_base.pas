unit dhtmlx_base;

{$mode objfpc}
{$modeswitch externalclass}

interface

uses
  js,Web;

type
  Tdhtmlx = class external name 'dhtmlx' (TJSElement)
    procedure message(msg : TJSObject);
    procedure alert(msg : TJSObject);
  end;
  Tdhx = class external name 'dhx' (TJSElement)
    dateFormat : TJSObject;
    dateLang : string;
    isChrome : Boolean;
    isIE : Boolean;
    isIE6 : Boolean;
    isIE7 : Boolean;
    isIE8 : Boolean;
    isIE9 : Boolean;
    isIE10 : Boolean;
    isIE11 : Boolean;
    isFF : Boolean;
    isEdge : Boolean;
    isIPad : Boolean;
    isKHTML : Boolean;
    isOpera : Boolean;
    function version : string;
  end;
  Tdhx4 = class external name 'dhx4' (TJSElement)
    skin : string;
  end;

procedure AppendCSS(url : string;onLoad,onError : JSValue);
procedure AppendJS(url : string;onLoad,onError : JSValue);

var
  dhtmlx : Tdhtmlx external name 'dhtmlx';
  dhx : Tdhx external name 'window.dhx';
  dhx4 : Tdhx external name 'window.dhx4';
  WidgetsetLoaded : TJSPromise;


implementation

procedure AppendCSS(url : string;onLoad,onError : JSValue);
begin
  asm
    var file = url;
    var link = document.createElement( "link" );
    link.href = file;
    link.type = "text/css";
    link.rel = "stylesheet";
    link.media = "screen,print";
    link.onload = onLoad;
    link.onerror = onError;
    document.getElementsByTagName( "head" )[0].appendChild( link );
  end;
end;
procedure AppendJS(url : string;onLoad,onError : JSValue);
begin
  asm
    if (document.getElementById(url) == null) {
      var file = url;
      var link = document.createElement( "script" );
      link.id = url;
      link.src = file;
      link.type = "text/javascript";
      link.onload = onLoad;
      link.onerror = onError;
      document.getElementsByTagName( "head" )[0].appendChild( link );
    }
  end;
end;

procedure LoadDHTMLX;
  procedure DoLoadDHTMLX(resolve,reject : TJSPromiseResolver) ;
    procedure ScriptLoadedJS;
    begin
      asm
        window.dhx4.skin = 'material';
      end;
      console.log('DHTMLX loaded...');
      resolve(true);
    end;
    procedure ScriptLoadedCSS2;
    begin
      AppendJS('https://cdn.dhtmlx.com/edge/dhtmlx.js',@ScriptLoadedJS,null);
    end;
    procedure ScriptErrorJS;
    begin
      AppendCSS('https://cdn.dhtmlx.com/edge/dhtmlx.css',@ScriptLoadedCSS2,null);
      //AppendCSS('https://cdn.dhtmlx.com/edge/fonts/font_awesome/css/font-awesome.min.css',null,null);
      AppendCSS('https://use.fontawesome.com/releases/v5.2.0/css/all.css',null,null);
      AppendCSS('https://use.fontawesome.com/releases/v5.2.0/css/v4-shims.css',null,null);
    end;
    procedure ScriptLoadedCSS;
    begin
      AppendJS('appbase/dhtmlx/dhtmlx.js',@ScriptLoadedJS,@ScriptErrorJS);
    end;
  begin
    console.log('Loading DHTMLX...');
    AppendCSS('appbase/dhtmlx/dhtmlx.css',@ScriptLoadedCSS,@ScriptErrorJS);
    AppendCSS('appbase/dhtmlx/fonts/font_awesome/css/font-awesome.min.css',null,null);
  end;
begin
  WidgetsetLoaded:=TJSPromise.New(@DoLoadDHTMLX);
end;

initialization
  LoadDHTMLX;
end.

