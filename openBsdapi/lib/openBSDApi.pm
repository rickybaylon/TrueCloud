package openBSDApi;
use Mojo::Base 'Mojolicious', -signatures;
use openBSDApi::Model::Data;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  # openAPI spec file
  $self->plugin(
      "OpenAPI" => {
	      url => $self->home->rel_file($config->{appfiles}->{openapispec})
      }
  );

  $self->plugin(
      SwaggerUI => {
          route => $self->routes()->any('api'),
          url => "/api/v1",
          title => "OpenBSD API"
      }
  );

  # Helper to lazy initialize and store our model object
  $self->helper(
      model => sub ($c) {
          state $data = openBSDApi::Model::Data->new($config->{appfiles});
          return $data;
      }
  );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Example#welcome');
}

1;
