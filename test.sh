#!/bin/bash

hy quine.hy > quine_output
diff quine.hy quine_output
