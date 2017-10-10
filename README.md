### Ajax in Rails ###

What does it do?
- The same Ajax you know and love.  Use it to speed things up, update the database or fetch data and update the page without reloading.

Where does this code go?  How do I set it up?
- Adding the `remote: true` attribute to a link, button, or form will disable the default Rails action and send an Ajax request or action instead.

- Adding the `respond_to` method to the controller allows us to render set up both html and javascript responses for controller actions. The `respond_to` method provides the ability to respond with many formats(i.e. csv, xml, etc…)for one or all actions in a controller.

- Adding a view file with the appropriate name and the suffix `js.erb` creates an ERB template that generates Javascript instead of HTML. The `js.erb` files we create will go under the view folder associated with the controller we are working with.

- Unobtrusive JavaScript (UJS) Ajax helpers handle the responses.  Use `ajax:success` to define actions triggered by a successful Ajax call and `ajax:error` to define actions triggered by a failed Ajax call.


See example code in the repo.

Resources:
https://blog.codeship.com/unobtrusive-javascript-via-ajax-rails/

https://launchschool.com/blog/the-detailed-guide-on-how-ajax-works-with-ruby-on-rails

http://guides.rubyonrails.org/working_with_javascript_in_rails.html#an-introduction-to-ajax
