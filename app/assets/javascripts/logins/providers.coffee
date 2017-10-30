
# new NewLoginProvidersFields(datas).requestFields()
# new NewLoginProvidersFields(datas).requestFields()

$(document).ready ->
  new LoginProvidersFields($('#login_provider_code').val()).requestFields()

$(document).on 'change', '#login_provider_code', (e) ->
  new LoginProvidersFields(e.target.value).requestFields()

class LoginProvidersFields
  constructor: (providerId) ->
    @providerId = providerId
    @request  = $.ajax '/providers/fields',
                  type: 'GET',
                  dataType: 'html',
                  data:
                    provider_id: @providerId


  requestFields: ->
    @request.success (data) ->
      $(document.querySelector('div.appender')).empty().append(data)
      $('.select2-input').select2()