import re

class ConversionMethods:
    """ Contains the methods to perform net mask notation conversions """

    def is_valid_cidr(self, crid):
        return str.isdigit(crid) and  0 <= int(crid) <= 32

    def is_valid_mask(self, mask):
        return re.match(r'^\d{3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', mask )

    def cidr_to_bits(self, cidr):

        int_cidr = int(cidr)
        if 0 <= int_cidr <= 32:
            return "1"*int_cidr+"0"*(32-int_cidr)
        return ""

    def split_bits_into_octets(self, bits):
        octet_list = ["", "", "", ""]

        for (index, bit) in enumerate(bits):
            octet_index = int(index/8)
            octet_list[octet_index] = octet_list[octet_index] + bit

        return octet_list

    def octet_to_digit(self, octet):

        reversed_octet = list(reversed(octet))

        single_bit_values = [2 ** index
                             for (index, bit) in enumerate(reversed_octet)
                             if bit == "1"]

        return sum(single_bit_values)

    def cidr_to_mask(self, cidr):
        """
        Converts a valid CIDR to dotted decimal notation

        Args:
            param1 (`str`): input cidr value
                example : ´8´
        Returns:
            converted value in decimal dotted notation
                example: `252.0.0.0`
            Returns "Invalid" if the input is not a valid cird value
        """
        if (not cidr) or (not self.is_valid_cidr(cidr)):
            return 'Invalid'

        bits = self.cidr_to_bits(cidr)
        octet_list = self.split_bits_into_octets(bits)

        mask_values = [str(self.octet_to_digit(octet))
                       for octet in octet_list]
        mask_string = ".".join(mask_values)

        return mask_string

    def mask_to_cidr(self, mask):
        """
        Converts a valid network mask in dotted decimal notation
        to the same vale inn CIDR.

        Args:
            param1 (`str`): input mask value
                example : ´252.0.0.0´
        Returns:
            converted value in prefiix lenght
                example: `8`
            Returns "Invalid" if the input is not a valid mask value
        """
        if not mask or not self.is_valid_mask(mask):
            return 'Invalid'

        octet_digits = mask.split('.')
        octets_in_bits=""

        for octet_digit in octet_digits:

            bits = ""
            octet_digit = int(octet_digit)

            for exponent in range(7,-1,-1):
                octet_new_value = octet_digit - (2 ** exponent)
                if octet_new_value >= 0:
                    bits += "1"
                    octet_digit = octet_new_value
                else:
                    bits += "0"
                if octet_digit == 0:
                    bits += "0"* (8 - len(bits))
                    break

            octets_in_bits+=bits

        return str(octets_in_bits.count('1'))

    def is_valid_ipv4(self, ip_to_validate):
        return re.match(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', ip_to_validate )
