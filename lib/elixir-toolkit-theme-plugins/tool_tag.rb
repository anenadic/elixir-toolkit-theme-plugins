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
                if tool["registry"]
                    tags = create_tags(tool["registry"])
                end
                %Q{<a
                    tabindex="0"
                    class="tool"
                    aria-description="#{tool["description"]}"
                    data-bs-toggle="popover"
                    data-bs-placement="bottom"
                    data-bs-trigger="focus"
                    data-bs-content="<h5>#{tool["name"]}</h5><div class='mb-2'>#{tool["description"]}</div><a href='#{tool["url"]} class='mt-2 me-2' 'target='_blank'><span class='badge bg-dark text-white hover-primary'><i class='fa-solid fa-link me-2'></i>Website</span></a>#{tags}"
                    data-bs-template="<div class='popover popover-tool' role='tooltip'><div class='popover-arrow'></div><h3 class='popover-header'></h3><div class='popover-body'></div></div>"
                    data-bs-html="true"
                    ><i class="fa-solid fa-wrench me-2"></i>#{ tool["name"] }</a>}
            end

            def find_tool(tool_id)
                tool = @tools.find { |t| t["id"] == tool_id.strip }
                return tool if tool
                
                raise Exception.new "Undefined tool ID: #{tool_id}"
            end

            def create_tags(registry)
                tags = ""

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

                tags
            end

            def create_tag(url, icon, label)
                "<a href='#{url}' class='mt-2 me-2'><span class='badge bg-dark text-white hover-primary'><i class='fa-solid #{icon} me-2'></i>#{label}</span></a>"
            end
        end
    end
    Liquid::Template.register_tag("tool", Jekyll::Ett::ToolTag)
end
