guard 'shell', all_on_start: true do
  watch %r{client/src/.+} do
    `npm run build`
  end
end

guard 'livereload', grace_period: 1.0 do
  watch(%r{public/.+})
  watch(%r{server/.+})
end

guard 'process', name: 'server', command: ['node_modules/.bin/coffee', 'server/index.coffee'] do
  watch(%r{server/.+})
end
