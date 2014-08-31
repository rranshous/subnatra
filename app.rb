require 'sinatra'

# TODO: figure out if etag is worth computing

before do
  content_type :json
end

helpers do
  def serialize obj
    obj.to_json
  end
end

get '/callbacks/:oid' do
  # return all the callbacks for the given object
  subscriber_set = SubscriberSet.for params[:oid]
  callbacks = subscriber_set.get_callbacks
  error 404 if callbacks.nil? || callbacks.empty?
  last_modified subscriber_set.last_updated_at
  serialize subscribers
end

post '/callbacks/:oid' do
  # add a callback for the object
  # if no callback is specified than dont add anything
  if SubscriberSet.for(params[:oid]).add_callback params[:url]
    status 201
  else
    error 400
  end
end

put '/callbacks/:oid' do
  # add a callback for the object
  if SubscriberSet.for(params[:oid]).add_callback params[:url]
    status 201
  else
    error 400
  end
end

delete '/callbacks/:oid/:curl' do
  # remove the specified callback url from the objects callbacks
  if SubscriberSet.for(params[:oid]).remove_callback params[:url]
    status 204
  else
    error 404
  end
end

delete '/callbacks/:oid' do
  # remove all the callbacks for the given object
  if SubscriberSet.for(params[:oid]).delete
    status 204
  else
    error 404
  end
end
