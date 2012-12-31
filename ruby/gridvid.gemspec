Gem::Specification.new do |s|
    s.name           = 'GridVid'
    s.version        = File.open('../VERSION').read  
    s.date           = 12/12/12
    s.summary        = ''
    s.description    = ''
    s.authors        = ['Christopher J. Hanks']
    s.email          = ['cjhanks@cpusage.com', 'info@gridvid.me'] 
    s.files          = [
                        'lib/gridvid.rb'      , 
                        'lib/gridvid/job.rb'  ,
                        'lib/gridvid/group.rb',
                        'lib/gridvid/net.rb'
                      ]
    s.homepage       = 'https://gridvid.me'
    s.add_dependency 'json'
    s.add_development_dependency "json"
end 
