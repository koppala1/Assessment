#################################### ASSESSMENT ANSWERS ###################################################
1. Create a new Rails app
Ans) 
step step 2 => rails new myapp
1 => cd path/to/your/directory
step 3 => cd myapp

############################################################################################################
2. Create a new model with a name and data of your choosing with some basic validations
Ans)
step 1 => rails generate model ModelName attribute1:string attribute2:integer
step 2 => rails db:migrate
step 3 => 

class ModelName < ApplicationRecord
  validates :attribute1, presence: true
  validates :attribute2, numericality: { only_integer: true }
end

############################################################################################################
3. Create a controller for this model that contains endpoints for create and update
i) No authentication is required
ii) Include some basic verification for submitted parameters
Ans)
step 1 => rails generate controller ControllerName
step 2 => 

class ControllerNameController < ApplicationController
  # Endpoint for creating a new record
  def create
    @model = ModelName.new(model_params)
    if @model.save
      render json: { message: 'Record created successfully', data: @model }, status: :created
    else
      render json: { error: 'Failed to create record', errors: @model.errors }, status: :unprocessable_entity
    end
  end

  # Endpoint for updating an existing record
  def update
    @model = ModelName.find(params[:id])
    if @model.update(model_params)
      render json: { message: 'Record updated successfully', data: @model }, status: :ok
    else
      render json: { error: 'Failed to update record', errors: @model.errors }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters method to whitelist attributes for mass assignment
  def model_params
    params.require(:model_name).permit(:attribute1, :attribute2)
  end
end

step 3 => 

Rails.application.routes.draw do
  resources :model_name, only: [:create, :update]
end

#######################################################################################################

4. Available third-party API endpoints should be configurable (backend support only, no need for GUI)
Ans) step 1 => 
# Access environment variables
endpoint_url = ENV['THIRD_PARTY_API_ENDPOINT_URL']

development:
  third_party_api_endpoint_url: 'http://example.com/api'

test:
  third_party_api_endpoint_url: 'http://test.example.com/api'

production:
  third_party_api_endpoint_url: 'https://api.example.com'

# Load configuration file
third_party_apis = YAML.load_file(Rails.root.join('config', 'third_party_apis.yml'))

# Access endpoint based on environment
endpoint_url = third_party_apis[Rails.env]['third_party_api_endpoint_url']

###########################################################################################################
5. When new data is stored or updated, all configured endpoints should be notified of the changes
Ans)

# app/services/webhook_service.rb
class WebhookService
  def self.notify_endpoints(data)
    webhooks = Webhook.all
    webhooks.each do |webhook|
      send_request(webhook.url, data)
    end
  end

  def self.send_request(url, data)
    # Use an HTTP client library like HTTParty or RestClient to send POST requests
    # Example:
    # response = RestClient.post(url, data.to_json, headers: { 'Content-Type': 'application/json' })
    # Handle response if needed
  rescue RestClient::ExceptionWithResponse => e
    # Handle errors
  end
end

# Inside your model or controller where data is created or updated
after_commit :notify_webhooks, on: [:create, :update]

def notify_webhooks
  WebhookService.notify_endpoints(self)
end

############################################################################################################

6. Third parties should be provided with means to verify the authenticity of the webhook request
Ans)

Shared Secret Key:
Generate a secret key that will be shared between your application and the third parties. This key should be securely exchanged and kept confidential.

Include Signature in Webhook Payload:
When sending the webhook request, include a signature calculated using the secret key and the payload data. This signature can be added as a custom header or within the payload itself.

Signature Calculation:
Use a secure hashing algorithm like HMAC (Hash-based Message Authentication Code) to calculate the signature. Combine the payload data with the secret key and hash the result. This ensures that any change in the payload or secret key will result in a different signature.

Verify Signature on Third Party's End:
On the third party's end, they should have access to the same secret key. When they receive a webhook request, they can recalculate the signature using the received payload data and the secret key. If the calculated signature matches the one received in the request, it verifies the authenticity of the webhook

Handling Unauthorized Requests:
If the signatures do not match or if the signature is missing, the third party should reject the request as unauthorized. Additionally, you can implement measures like rate limiting and IP whitelisting to enhance security

#########################################################################################################################################
