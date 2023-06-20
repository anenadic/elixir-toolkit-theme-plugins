require "jekyll"


module Jekyll
    class Ett
        class ToolTag < Liquid::Tag
            def initialize(tagName, content, tokens)
                super
                @content = content
                load_tools
            end

            def load_tools
                tools_path = File.join(Dir.pwd, "_data", "tool_and_resource_list.yml")
                @tools = YAML.load(File.read(tools_path))
            end

            def render(context)
                tool = find_tool(context[@content.strip])
                tags = create_tags(tool)
                %Q{#{"<div class='dropdown d-inline'>
                    <a class='tool' type='button' aria-description='%{description}' data-bs-toggle='dropdown' data-bs-auto-close='outside'>
                    <i class='fa-solid fa-wrench me-2'></i>%{name}</a>
                    <div class='dropdown-menu shadow border-0'>
                        <div class='card'>
                            <div class='card-body'>
                                <h5>%{name}</h5>
                                <div class='mb-2'>%{description}</div>
                                %{tags}
                            </div>
                        </div>
                    </div>
                </div>" % {name: tool["name"], description: tool["description"], tags: tags }}}
            end

            def find_tool(tool_id)
                tool = @tools.find { |t| t["id"] == tool_id }
                return tool if tool
                
                raise Exception.new "Undefined tool ID: #{tool_id}"
            end

            def create_tags(tool)
                tags = ""
                tags << create_tag("#{tool["url"]}", "fa-link", "Website")
                if tool["registry"]
                    registry = tool["registry"]

                    if registry["biotools"]
                        tags << create_tag("https://bio.tools/#{registry["biotools"]}", "fa-info", "Tool info")
                    end

                    if registry["fairsharing"]
                        tags << create_tag("https://fairsharing.org/FAIRsharing.#{registry["fairsharing"]}", "fa-database", "Standards/Databases")
                    end

                    if registry["fairsharing-coll"]
                        tags << create_tag("https://fairsharing.org/#{registry["fairsharing-coll"]}", "fa-database", "Standards/Databases")
                    end

                    if registry["tess"]
                        tags << create_tag("https://tess.elixir-europe.org/search?q=#{registry["tess"]}", "fa-graduation-cap", "Training")
                    end
                end
                tags
            end

            def create_tag(url, icon, label)
                "<a href='#{url}' class='mt-2 me-2'><span class='badge bg-dark text-white hover-primary'><i class='fa-solid #{icon} me-2'></i>#{label}</span></a>"
            end
        end
    end
    Liquid::Template.register_tag("tool", Jekyll::Ett::ToolTag)
end
