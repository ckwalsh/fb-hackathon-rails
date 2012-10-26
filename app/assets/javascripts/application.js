// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

function fb_init() {
  FB.getLoginStatus(function(response) {
    if (response.status === 'connected') {
      fs_init();
    }
  });
}

function fs_init() {
  var friend_selector = $("#jfmfs-container");
  if (typeof friends_selected == 'undefined') {
    friends_selected = [];
  }
  if (friend_selector) {
    friend_selector.jfmfs({
      pre_selected_friends: friends_selected,
    });
  }
}

function fb_login() {
  FB.login(function (response) {
    if (response.authResponse) {
      window.location.reload();
    }
  }, {scope: 'publish_stream,read_stream,user_likes'});
}

function fb_logout() {
  FB.logout(function(response) {
    window.location.reload();
  });
}

function read_friend_list(node) {
  var friend_selector = $("#jfmfs-container");
  if (friend_selector) {
    var selector = friend_selector.data('jfmfs');
    var ids = selector.getSelectedIds();
    form = $(node.form);
    for (var i in ids) {
      var id = ids[i];
      input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'friends[]';
      input.value = id;
      form.append(input);
    }
  }
}
