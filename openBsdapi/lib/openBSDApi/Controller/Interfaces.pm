package openBSDApi::Controller::Interfaces;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::JSON qw(encode_json);

sub get_interfaces ($self) {

    # Do not continue on invalid input and render a default 400 error document.
    my $app = $self->openapi->valid_input or return;

    my $data_in_json = $app->model->get_openbsd_data();

    # $output will be validated by the OpenAPI spec before rendered
    my $output = {interfaces => $data_in_json->{interfaces}};
    $app->render(openapi => $output);
}

sub get_interface ($self) {

    my $app = $self->openapi->valid_input or return;

    my $data_in_json = $app->model->get_openbsd_data();
    my $if_id = $app->param("id");

    if ($if_id < scalar(@{$data_in_json->{interfaces}})) {
      $app->render(openapi => $data_in_json->{interfaces}[$if_id]);
    } else {
      $app->render(openapi => {message => "Item not found: ".$if_id}, status => 404);
    }
}

sub del_interface ($self) {

    my $app = $self->openapi->valid_input or return;

    my $data_in_json = $app->model->get_openbsd_data();
    my $if_id = $app->param("id");

    if ($if_id < scalar(@{$data_in_json->{interfaces}})) {
      splice(@{$data_in_json->{interfaces}}, $if_id, 1);
      my $rt = $app->model->save_data($data_in_json);
      if ($rt == 0){
        $app->render(openapi => {message => "Error saving config file."}, status => 400);
      } else {
        $app->render(openapi => {message => "Interface deleted."});
      }
    } else {
      $app->render(openapi => {message => "Item not found: ".$if_id}, status => 404);
    }
}

sub add_interface ($self) {

    my $app = $self->openapi->valid_input or return;

    my $data_in_json = $app->req->json;
    my $openbsd_data = $app->model->get_openbsd_data();
    push(@{$openbsd_data->{interfaces}}, $data_in_json);

    my $rt = $app->model->save_data($openbsd_data);
    if ($rt == 0){
        $app->render(openapi => $data_in_json, status => 400);
    } else {
        my $output = {interfaces => $openbsd_data->{interfaces}};
        $app->render(openapi => $output);
    }
}

sub update_interface ($self) {

    my $app = $self->openapi->valid_input or return;

    my $data_in_json = $app->req->json;
    my $openbsd_data = $app->model->get_openbsd_data();
    my $if_id = $app->param("id");
    if ($if_id >= scalar(@{$openbsd_data->{interfaces}})) {
      $app->render(openapi => {message => "Item not found: ".$if_id}, status => 404);
    } else {
      $openbsd_data->{interfaces}[$if_id] = $data_in_json;
      my $rt = $app->model->save_data($openbsd_data);
      if ($rt == 0){
        $app->render(openapi => $data_in_json, status => 400);
      } else {
        my $output = {interfaces => $openbsd_data->{interfaces}};
        $app->render(openapi => $output);
      }
    }
}


1;
