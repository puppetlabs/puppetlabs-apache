# @summary The priority on vhost
type Apache::Vhost::Priority = Variant[Pattern[/^\d+$/], Integer, Boolean]
