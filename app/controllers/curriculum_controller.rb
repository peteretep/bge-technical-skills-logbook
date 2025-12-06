class CurriculumController < ApplicationController
  before_action :authenticate_user!

  def index
    @sections_by_category = Section.ordered.includes(:skills, :experiences_outcomes).group_by(&:category)

    # Calculate statistics
    @total_skills = Skill.count
    @total_sections = Section.count
    @skills_by_level = {
      bronze: Skill.bronze.count,
      silver: Skill.silver.count,
      gold: Skill.gold.count
    }

    # Category configuration
    @categories = {
      "Design and Construct" => {
        icon: "🔨",
        gradient: "from-blue-500 to-blue-600",
        border: "border-blue-500",
        text_color: "text-blue-600",
        description: "Hand tools and workshop processes"
      },
      "Materials" => {
        icon: "🌳",
        gradient: "from-green-500 to-green-600",
        border: "border-green-500",
        text_color: "text-green-600",
        description: "Wood, plastics, metals, and sustainability"
      },
      "Graphics" => {
        icon: "🎨",
        gradient: "from-orange-500 to-orange-600",
        border: "border-orange-500",
        text_color: "text-orange-600",
        description: "Sketching, CAD, graphic design, and digital fabrication"
      }
    }
  end
end
