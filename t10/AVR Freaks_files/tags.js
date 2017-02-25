
var Tags = Class.create();

Tags.prototype = {
  // URL to the PHP page called for receiving data for compare devices
  fUrl: '../../../index.php',
  form_element: undefined,

  initialize: function() {
  
  },
  
  addTags: function(event) {
    Event.stop(event);
    var element = Event.element(event);
    var el_id = element.getAttribute('id');

    this.form_element = element;

    var pars = 'module=FreaksTags&type=admin&func=saveTags&' + Form.serialize(el_id) + '&ajax=true';

    Form.disable(el_id);

    var tags_exist = $('tags');

    var myAjax = new Ajax.Request(
      this.fUrl, 
      {
        method: 'post', 
        parameters: pars,
        onComplete: function(originalRequest){
          Form.enable(el_id);
          Element.hide('tag_spinner');
          Form.reset(el_id);

          if (tags_exist) {
            var tags = $('tags');
            tags.innerHTML = originalRequest.responseText;
            new Effect.Highlight($('tags'), {startcolor:"#cccccc"});
          }
        }.bindAsEventListener(tags),
        onLoading: function(originalRequest){
          Element.show('tag_spinner')
        },
        onFailure: this.reportError.bindAsEventListener(tags)
      }
    );
  },
  
  reportError: function() {
    alert('An error occured when trying to add tags');
  }
}

var tags = new Tags();

var tagsRules = {
  '#tagsform': function( element ) {
    Event.observe(element, "submit", tags.addTags.bindAsEventListener(tags), false);
  }
}

Behaviour.register(tagsRules);