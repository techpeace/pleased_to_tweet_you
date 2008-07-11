// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var SignUp = {}
SignUp = {
  disableForm: function() {
     Form.disable('sign-up-form');
  },
  enableForm: function(form) {
     Form.enable('sign-up-form');
  }
}

 function changeInputs()
 {
 var els = document.getElementsByTagName('input');
 var elsLen = els.length;
 var i = 0;
 for ( i=0;i<elsLen;i++ )
 {
 if ( els[i].getAttribute('type') )
 {
 if ( els[i].getAttribute('type') == "text" )
 els[i].className = 'text';
 else
 els[i].className = 'button';
 }
 }
 }
