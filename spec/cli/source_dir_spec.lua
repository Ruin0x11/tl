local util = require("spec.util")

describe("-s --source-dir argument", function()
   it("recursively traverses the directory by default", function()
      util.run_mock_project(finally, {
         dir_name = "source_dir_traversal_test",
         dir_structure = {
            ["tlconfig.lua"] = [[return { source_dir = "src" }]],
            ["src"] = {
               ["foo.tl"] = [[print "foo"]],
               ["bar.tl"] = [[print "bar"]],
               foo = {
                  ["bar.tl"] = [[print "bar"]],
                  baz = {
                     ["foo.tl"] = [[print "baz"]],
                  }
               }
            }
         },
         cmd = "build",
         generated_files = {
            ["src"] = {
               "foo.lua",
               "bar.lua",
               foo = {
                  "bar.lua",
                  baz = {
                     "foo.lua"
                  }
               }
            }
         },
      })
   end)
   it("should die when the given directory doesn't exist", function()
      util.run_mock_project(finally, {
         dir_name = "no_source_dir_test",
         dir_structure = {
            ["tlconfig.lua"] = [[return {source_dir="src"}]],
            ["foo.tl"] = [[print 'hi']],
         },
         cmd = "build",
         generated_files = {},
         cmd_output = "Build error: source_dir 'src' doesn't exist\n",
      })
   end)
end)
