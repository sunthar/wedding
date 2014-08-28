PS = {
  call: function(method, params, callback, error, scope) {
    $.ajax({
      url: "/api/" + method,
      type: "GET",
      data: params,
      dataType: "json",
      success: function(data) {
        if (data.result && callback)
          callback.call(scope, data.result);
        if (data.error && error)
          error.call(scope, data.error);
      },
      error: function(err) {
        console.log(err);
      }
    });
  }
};