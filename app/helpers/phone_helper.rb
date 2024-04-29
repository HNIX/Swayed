module PhoneHelper
  def self.valid?(phone_number)
    parsed_phone = Phonelib.parse(phone_number)
    parsed_phone.valid?
  end

  def self.format_phone_number(phone_number, format: :numbers_only, include_country_code: false)
    # Remove any non-digit characters from the phone number
    digits = phone_number.gsub(/\D/, "")
    # Extract the country code, area code, and local number
    country_code, area_code, local_number = extract_parts(digits)
    # Include the country code if requested
    formatted_number = include_country_code ? "+#{country_code}" : ""
    case format
    when :numbers_only
      formatted_number += "#{area_code}#{local_number}"
    when :numbers_and_dashes
      formatted_number += "#{area_code}-#{local_number[0, 3]}-#{local_number[3, 4]}"
    else
      formatted_number
    end
    formatted_number
  end

  def self.extract_parts(digits)
    country_code = if digits.start_with?("1") && digits.length == 11
      digits.slice!(0)
    else
      "1"
    end

    area_code = digits.slice!(0, 3)

    local_number = digits

    [country_code, area_code, local_number]
  end
end
