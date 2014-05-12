# $Id$

package FileList::Plugin;

use strict;
use warnings;
use Data::Dumper;

sub plugin {
    return MT->component('FileList');
}

#---- listing framework


sub file_list_template_link{
# show link for template.
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $template_id = $obj->template_id;
    my $blog_id = $obj->blog_id;
    my $admincgipath = $app->config->AdminCGIPath;
    my $adminsctipt = $app->config->AdminScript;
    my $template_info = MT->model('template')->load( {id => $template_id, blog_id => $blog_id} );
    my $link_text = $template_info->name;
    my $html = '<a href="'.$admincgipath.$adminsctipt.'?__mode=view'.'&_type=template'.'&blog_id='.$blog_id.'&id='.$template_id.'" target="_blank" >'.$link_text.'</a>';
    return $html;
}

sub file_list_entry_link{
# show link for template.
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $entry_id = $obj->entry_id;
    if ($entry_id) {
        my $blog_id = $obj->blog_id;
        my $admincgipath = $app->config->AdminCGIPath;
        my $adminsctipt = $app->config->AdminScript;
        my $entry_info = MT->model('entry')->load( {id => $entry_id, blog_id => $blog_id} );
        my $link_text = $entry_info->title;
        my $html = '<a href="'.$admincgipath.$adminsctipt.'?__mode=view'.'&_type=entry'.'&blog_id='.$blog_id.'&id='.$entry_id.'" target="_blank" >'.$link_text.'</a>';
        return $html;
    } else {
        return '';
    }
}

sub file_list_publish_url_link{
# show url for file
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $url = $obj->url;
    my $blog_id = $obj->blog_id;
    my $blog_info = MT->model('blog')->load( {id => $blog_id} );
    my $blog_site_url = $blog_info->site_url;
    my $link_text = $obj->url;
    my $html = '<a href="'.$blog_site_url.$url.'" target="_blank" >'.$link_text.'</a>';
    return $html;
}

sub file_list_archive_type{
# show url for file
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $archive_type = $obj->archive_type;
    my $text = MT->translate($archive_type);
    return $text;
}


sub file_list_view_link {
# if dymamic publishing. show 'dynamic' else show link for viewer.
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $id = $obj->id;
    my $blog_id = $obj->blog_id;
    my $template_id = $obj->template_id;
    my $template_map = MT->model('templatemap')->load({template_id=>$template_id, blog_id=>$blog_id});
    my $pub_mode = $template_map->{'column_values'}->{'build_type'};
    my $html;
    if ($pub_mode eq '3') {
        $html = MT->translate('Dynamic Publishing');
    } else {
        my $admincgipath = $app->config->AdminCGIPath;
        my $adminsctipt = $app->config->AdminScript;
#    my $link_text = MT->translate("View Published File");
        my $link_text = $obj->file_path;
        $html = '<a href="'.$admincgipath.$adminsctipt.'?__mode=file_list_file_view'.'&_type=filelist'.'&blog_id='.$blog_id.'&id='.$id.'" target="_blank" >'.$link_text.'</a>';
    }



    return $html;
#    return $link_text;

}

sub file_list_file_publish_datetime {
# if static publishing. show datetime of last publish (file modified date).

}

sub file_list_file_view {
    my $app = shift;
    my (%opt) = @_;

    my $q = $app->{query};
    my $blog_id = scalar $q->param('blog_id');
    my $id   = scalar $q->param('id');
    my $tmpl = $app->load_tmpl('file_view.tmpl');

    my $fileinfo = MT->model('fileinfo')->load({id => $id, blog_id=>$blog_id});
    my $file_path = $fileinfo->file_path;
    my $text;
    {
        use open IO => ":utf8";
        open( IN, "<$file_path" );
        local $/ = undef;
        $text = <IN>;
        close(IN);
    }


    $tmpl->param('file_list_file_text'   => $text);
    $tmpl->param('file_list_file_path' => $file_path);

    $app->add_breadcrumb( $app->translate("Main Menu"), $app->{mtscript_url});
    require MT::Blog;
    my $blog = MT::Blog->load ($blog_id);
    $app->add_breadcrumb( $blog->name, $app->mt_uri( mode => 'menu', args => { blog_id => $blog_id }));
    $app->add_breadcrumb($app->translate("FileList"));
    $tmpl->param(breadcrumbs => $app->{breadcrumbs});

    return $app->build_page($tmpl);
}


1;
