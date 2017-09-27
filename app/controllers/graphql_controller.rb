class GraphqlController < ApplicationController
  def execute
    variables = params[:variables]
    variables = JSON.parse(variables) if variables && variables.is_a?(String)
    variables ||= {}
    result = BeardenSchema.execute(
      params[:query],
      variables: variables,
      context: {},
      operation_name: params[:operationName]
    )
    render json: result
  end
end
