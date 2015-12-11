// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( function () {
    $('#user-links-table').DataTable( {
    	scrollY: 400,
    	paging: false
    } );
} );

$(document).ready( function () {
    $('#favorite-links-table').DataTable( {
    	scrollY: 400,
    	paging: false
    } );
} );

function favorite(linkID, userID) {
    $.ajax({
      method: "PUT",
      url: "/api/links/" + linkID + "/favorite",
      data: { user_id: userID }
    })
      .done(function( msg ) {
      	status = msg["status"];

      	if(status == 1) {
      		$("#favorited").html("(Favorited)");
      		var current_onclick = $(".favorite_button").attr("onclick");
      		var new_onclick = "un" + current_onclick;
      		$(".favorite_button").attr("onclick", new_onclick);
      		$(".favorite_button").html("Remove This Link From Your Favorites");
      	}

      });
};

function unfavorite(linkID, userID) {
    $.ajax({
      method: "PUT",
      url: "/api/links/" + linkID + "/unfavorite",
      data: { user_id: userID }
    })
      .done(function( msg ) {
      	status = msg["status"];

      	if(status == 1) {
      		$("#favorited").html("");
      		var current_onclick = $(".favorite_button").attr("onclick");
      		var new_onclick = current_onclick.slice(2);
      		$(".favorite_button").attr("onclick", new_onclick);
      		$(".favorite_button").html("Favorite This Link!");
      	}

      });
};