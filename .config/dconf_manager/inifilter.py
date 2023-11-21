#!/usr/bin/env python3

"""Applies a filter to a .ini file"""

import argparse
from configparser import ConfigParser
import sys
from typing import Iterable


def parse(filelike: Iterable[str]) -> ConfigParser:
    """Creates a parser instance from a file"""
    parser = ConfigParser(allow_no_value=True)
    parser.read_file(filelike)
    return parser


def apply_filter(input_data: ConfigParser, filter_data: ConfigParser) -> ConfigParser:
    """Applies filter to input_data and returns a new ConfigParser instance"""
    # Copy input
    output = ConfigParser()
    output.read_dict(input_data)

    # Filter sections
    for section in output.sections():
        if section not in filter_data.sections():
            output.remove_section(section)
        else:
            # Check if section has a whitelist for keys
            # Indexing should never fail due to the previous condition
            fsection_keys = filter_data[section].keys()
            if len(fsection_keys):
                for key in output[section].keys():
                    if key not in fsection_keys:
                        output.remove_option(section, key)

    return output


if __name__ == "__main__":
    args_parser = argparse.ArgumentParser(
        "inifilter", description="Filters the content of a .ini file"
    )

    args_parser.add_argument("input", help='Input file location (or "stdin")')
    args_parser.add_argument("filter_path", help="Filter config file location")
    args_parser.add_argument("output", help='Output file location (or "stdout")')
    args = args_parser.parse_args()

    # Open filter file
    with open(args.filter_path, "r", encoding="UTF-8") as filter_file:
        parsed_filter = parse(filter_file)

    # Read input
    if args.input == "stdin":
        parsed_input = parse(sys.stdin)
    else:
        with open(args.input, "r", encoding="UTF-8") as input_file:
            parsed_input = parse(input_file)

    # Apply filter
    result = apply_filter(parsed_input, parsed_filter)

    # Write result to output
    if args.output == "stdout":
        result.write(sys.stdout)
    else:
        with open(args.output, "w+", encoding="UTF-8") as output_file:
            result.write(output_file)
