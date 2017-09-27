bashrc_manager 'test1' do
  user 'test_user'
  content 'test1'
end

bashrc_manager 'test2' do
  action :remove
  user 'test_user'
end
