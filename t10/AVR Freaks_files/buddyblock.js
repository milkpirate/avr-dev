var buddyBlock = {
  init: function() {
    toggle('addBuddy');
  }
}

var buddyBlockRules = {
  '#add_a_buddy' : function( element ) {
    element.onclick = function() {
      toggle('addBuddy'); 
      return false;
    }
  }
}

Behaviour.register(buddyBlockRules);
register_onload_function(buddyBlock.init);