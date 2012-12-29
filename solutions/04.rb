class Validations
    def email?(value)

    end

    def phone?(value)
        
    end

    def hostname?(value)
        mtld = /(?<=\.)[a-zA-Z]{2,3}(\.[a-zA-Z]*){,1}$/.match value
        tld = mtld[0]
        domain = /([a-zA-Z0-9][a-zA-Z0-9\-]{,61}[a-zA-Z0-9].)+/ =~ value

    end

    def ip_address?(value)
        
    end

    def number?(value)
        
    end

    def integer?(value)
        
    end

    def date?(value)
        
    end

    def time?(value)
        
    end

    def date_time?(value)

    end
end

class PrivacyFilter
    attr_accessor :text
    EREPLACE = '[EMAIL]'
    PREPLACE = '[PHONE]'
    FREPLACE = '[FILTERED]'

    def initialize(data)
        @text = data
        @preserve_phone_country_code = false
        @preserve_email_hostname = false
        @partially_preserve_email_username = false
    end

    def filtered
    end

    def preserve_phone_country_code
        @preserve_phone_country_code = not @preserve_phone_country_code
    end

    def preserve_email_hostname
        @preserve_email_hostname = not @preserve_email_hostname
    end

    def partially_preserve_email_username
        @partially_preserve_email_username = not @partially_preserve_email_username
    end
end