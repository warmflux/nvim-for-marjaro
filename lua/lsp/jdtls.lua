local ok, jdtls = pcall(require, "jdtls")
if not ok then
	return
end

local home = os.getenv("HOME")

local config = {
	cmd = {
		"jdtls",
		"--jvm-arg=-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
	},
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
	settings = {
		java = {
			autobuild = { enabled = true },
			home = os.getenv("JAVA_HOME"),

			maven = {
				userSettings = "/home/feng/.m2/settings.xml",
				downloadSources = true,
			},
		},
	},
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		jdtls.start_or_attach(config)
	end,
})
