from functions.conversions.modules.networking import ConversionMethods
import unittest


class TestStringMethods(unittest.TestCase):
    def setUp(self):
        self.convert = ConversionMethods()

    def test_cidr_to_bits(self):
        test_value_list = [
            ('10000000000000000000000000000000', '1'),
            ('11111111111111000000000000000000', '14'),
            ('11111111111111111100000000000000', '18'),
            ('11111111111111111111111111111111', '32')
        ]
        for (expected_result, cidr) in test_value_list:
            self.assertEqual(
                expected_result,
                self.convert.cidr_to_bits(cidr)
            )

    def test_cidr_to_bits_invalid_cidr(self):
        invalid_cidr = '33'
        self.assertFalse(
            self.convert.cidr_to_bits(invalid_cidr)
        )

    def test_split_bits_into_octets(self):
        test_value_list = [
            (['10000000', '00000000', '00000000', '00000000'],
             '10000000000000000000000000000000'),
            (['11111111', '11111100', '00000000', '00000000'],
             '11111111111111000000000000000000'),
            (['11111111', '11111111', '11000000', '00000000'],
             '11111111111111111100000000000000'),
            (['11111111', '11111111', '11111111', '11111111'],
             '11111111111111111111111111111111')
        ]

        for (expected_result, bits) in test_value_list:
            self.assertEqual(
                expected_result,
                self.convert.split_bits_into_octets(bits)
            )

    def test_octet_to_digit(self):
        test_value_list = [
            (0, '00000000'),
            (255, '11111111'),
            (240, '11110000'),
            (252, '11111100')
        ]

        for (expected_result, octet) in test_value_list:
            self.assertEqual(
                expected_result,
                self.convert.octet_to_digit(octet)
            )

    def test_valid_cidr_to_mask(self):
        test_value_list = [
            ('128.0.0.0', '1'),
            ('255.0.0.0', '8'),
            ('255.255.0.0', '16'),
            ('255.255.255.0', '24'),
            ('255.255.254.0', '23'),
            ('255.255.255.255', '32'),
        ]
        for (expected_result, cidr) in test_value_list:
            self.assertEqual(
                expected_result,
                self.convert.cidr_to_mask(cidr)
            )

    def test_valid_mask_to_cidr(self):

        test_value_list = [
            ('1', '128.0.0.0'),
            ('12', '255.240.0.0'),
            ('15', '255.254.0.0'),
            ('32', '255.255.255.255'),
        ]

        for expected_value, test_value in test_value_list:
            self.assertEqual(
                expected_value, self.convert.mask_to_cidr(test_value))

    def test_invalid_cidr_to_mask(self):
        self.assertEqual('Invalid', self.convert.cidr_to_mask('-1'))

    def test_invalid_mask_to_cidr(self):
        self.assertEqual('Invalid', self.convert.mask_to_cidr('0.0.0.0'))

    def test_valid_ipv4(self):
        self.assertTrue(self.convert.is_valid_ipv4('127.0.0.1'))

    def test_invalid_ipv4(self):
        self.assertFalse(self.convert.is_valid_ipv4('192.168.1.2.3'))
