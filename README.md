### Ajax in Rails ###

What does it do?
- The same Ajax you know and love.  Use it to speed things up, update the database or fetch data and update the page without reloading.

Where does this code go?  How do I set it up?
- Adding the `remote: true` attribute to a link, button, or form will disable the default Rails action and send an Ajax request or action instead.

- Adding the `respond_to` method to the controller allows us to render set up both html and javascript responses for controller actions. The `respond_to` method provides the ability to respond with many formats(i.e. csv, xml, etc…)for one or all actions in a controller.

- Adding a view file with the appropriate name and the suffix `js.erb` creates an ERB template that generates Javascript instead of HTML. The `js.erb` files we create will go under the view folder associated with the controller we are working with.

- Use `ajax:success` to define actions triggered by a successful Ajax call and `ajax:error` to define actions triggered by a failed Ajax call.


See example code in the repo.

Resources:
https://blog.codeship.com/unobtrusive-javascript-via-ajax-rails/

https://launchschool.com/blog/the-detailed-guide-on-how-ajax-works-with-ruby-on-rails

http://guides.rubyonrails.org/working_with_javascript_in_rails.html#an-introduction-to-ajax




<a href="#" onclick="this.style.backgroundColor='#990000'">Paint it red</a>



/app/controllers/things_controller.rb
class ThingsController < ApplicationController
  def show
    render js: "alert('The number is: #{params[:id]}')"
  end 
End

In the index page view for Thing, we’ll create a link that calls the show resource via AJAX.
<%# /app/views/things/index.html.erb %>
<%= link_to 'Number Alert', thing_path(42), remote: true %>

If we rename our default show template for Thing from show.html.erb to show.js.erb, we can drop our JavaScript in there, remove the render command from the controller, and we get the same behavior.
# /app/controllers/things_controller.rb
class ThingsController < ApplicationController
  def show
  end 
end
And the view for show with erb substitution would be written as:
<%# /app/views/things/show.js.erb %>
alert('Number <%= params[:id] %>')
Clicking the link will produce the same result: “The number is: 42.”
We’ll use the index page for the Thing model as an example.
<%# /app/views/things/index.html.erb %>
<%= link_to 'Change Below', thing_path(42), remote: true %>

<div id="target-for-change">
  Now you see "ME"!
</div>
Next we’ll create a partial HTML page for replacing the content inside the div tags.
<%# /app/views/things/_show.html.erb %>
Now you don't!
In our show template, we’ll target the div id for the index page and render that partial content as HTML inside it.
<%# /app/views/things/show.js.erb %>
$("#target-for-change").html("<%= j render(partial: 'show') %>");
If you click the Change Below link, the content changes instantly from Now you see “Me”! to Now you don’t! 
There’s a lot happening here, so let me clarify the different parts in show.js.erb. First of all, the dollar sign is a JavaScript reference to jQuery; the parenthesis that follows allows you to select a part of your webpage with a CSS selector. In this case, we’re selecting anything that has the id of target-for-change. 
Next, we call the jQuery method on the selected part of the page to replace the HTML within the selected content to the string provided. The ERB part you see with render(partial: ‘show’)gets the HTML from _show.html.erb, and the j method string-escapes it in order to be acceptable as a proper string value in JavaScript. Anytime you render a “partial,” the file name will always be proceeded with an underscore so there is no confusion between _show.html.erb and show.js.erb in template rendering.


Event name
Extra parameters
Fired
ajax:before


Before the whole ajax business, aborts if stopped.
ajax:beforeSend
xhr, options
Before the request is sent, aborts if stopped.
ajax:send
xhr
When the request is sent.
ajax:success
xhr, status, err
After completion, if the response was a success.
ajax:error
xhr, status, err
After completion, if the response was an error.
ajax:complete
xhr, status
After the request has been completed, no matter the outcome.
ajax:aborted:file
elements
If there are non-blank file inputs, aborts if stopped.




form_with is a helper that assists with writing forms. By default, form_with assumes that your form will be using Ajax. You can opt out of this behavior by passing the :local option form_with.
<%= form_with(model: @article) do |f| %>
  ...
<% end %>
This will generate the following HTML:
<form action="/articles" method="post" data-remote="true">
  ...
</form>
Note the data-remote="true". Now, the form will be submitted by Ajax rather than by the browser's normal submit mechanism.
You probably don't want to just sit there with a filled out <form>, though. You probably want to do something upon a successful submission. To do that, bind to the ajax:success event. On failure, use ajax:error. Check it out:
$(document).ready ->
  $("#new_article").on("ajax:success", (e, data, status, xhr) ->
    $("#new_article").append xhr.responseText
  ).on "ajax:error", (e, xhr, status, error) ->
    $("#new_article").append "<p>ERROR</p>"
3.2.1 data-method
Activating hyperlinks always results in an HTTP GET request. However, if your application is RESTful, some links are in fact actions that change data on the server, and must be performed with non-GET requests. This attribute allows marking up such links with an explicit method such as "post", "put" or "delete".
The way it works is that, when the link is activated, it constructs a hidden form in the document with the "action" attribute corresponding to "href" value of the link, and the method corresponding to data-method value, and submits that form.
Because submitting forms with HTTP methods other than GET and POST isn't widely supported across browsers, all other HTTP methods are actually sent over POST with the intended method indicated in the _method parameter. Rails automatically detects and compensates for this.
3.2.2 data-url and data-params
Certain elements of your page aren't actually referring to any URL, but you may want them to trigger Ajax calls. Specifying the data-url attribute along with the data-remote one will trigger an Ajax call to the given URL. You can also specify extra parameters through the data-params attribute.
This can be useful to trigger an action on check-boxes for instance:
<input type="checkbox" data-remote="true"
    data-url="/update" data-params="id=10" data-method="put">
3.2.3 data-type
It is also possible to define the Ajax dataType explicitly while performing requests for data-remoteelements, by way of the data-type attribute.
Imagine you have a series of users that you would like to display and provide a form on that same page to create a new user. The index action of your controller looks like this:
class UsersController < ApplicationController
  def index
    @users = User.all
    @user = User.new
  end
  # ...
The index view (app/views/users/index.html.erb) contains:
<b>Users</b>
 
<ul id="users">
<%= render @users %>
</ul>
 
<br>
 
<%= form_with(model: @user) do |f| %>
  <%= f.label :name %><br>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>
The app/views/users/_user.html.erb partial contains the following:
<li><%= user.name %></li>
The top portion of the index page displays the users. The bottom portion provides a form to create a new user.
The bottom form will call the create action on the UsersController. Because the form's remote option is set to true, the request will be posted to the UsersController as an Ajax request, looking for JavaScript. In order to serve that request, the create action of your controller would look like this:
# app/controllers/users_controller.rb
# ......
def create
  @user = User.new(params[:user])
 
  respond_to do |format|
    if @user.save
      format.html { redirect_to @user, notice: 'User was successfully created.' }
      format.js
      format.json { render json: @user, status: :created, location: @user }
    else
      format.html { render action: "new" }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end
Notice the format.js in the respond_to block; that allows the controller to respond to your Ajax request. You then have a corresponding app/views/users/create.js.erb view file that generates the actual JavaScript code that will be sent and executed on the client side.
$("<%= escape_javascript(render @user) %>").appendTo("#users");