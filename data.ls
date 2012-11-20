exports.data =
  site:
    template: 'octoish'
    pages:
      * Home:
          * markdown: "
            A First Level Header
            ====================

            Now is the time for all good men to come to
            the aid of their country. This is just a
            regular paragraph. "
        * Contact:
            * h1: 'Contact'
            * form:
                emailto: 'ithkuil@gmail.com'
                fields:
                  * name: 'string'
                  * email: 'string'
                  * message: 'string'
                      

