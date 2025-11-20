# db/seeds.rb

puts "🌱 Seeding database..."

# Only clear student-related data, keep sections and skills
# This allows re-running seeds without losing section/skill structure
Badge.destroy_all
StudentSkill.destroy_all
Student.destroy_all
Classroom.destroy_all
# Note: We keep User data - only clear if you want fresh demo data
# User.destroy_all  # Uncomment if you want to reset demo teacher

puts "✅ Cleared existing student/classroom data (keeping sections and skills)"

# Helper method to create skills idempotently
def create_skill_if_needed(section, level, description, position)
  Skill.find_or_create_by!(
    section: section,
    description: description
  ) do |skill|
    skill.level = level
    skill.position = position
  end
end

# SECTION 1: HAND TOOLS - MEASURING AND MARKING
section1 = Section.find_or_create_by!(name: "Hand Tools: Measuring and Marking") do |s|
  s.category = "Design and Construct"
  s.description = "Accurate measuring and marking is the foundation of quality work."
  s.icon = "📏"
  s.position = 1
end

# Bronze Skills
bronze_skills_s1 = [
  {
    section: section1,
    level: :bronze,
    description: "Use a steel rule to measure lengths accurately to the nearest millimetre",
    position: 1
  },
  {
    section: section1,
    level: :bronze,
    description: "Mark lines on wood using a pencil and ruler",
    position: 2
  },
  {
    section: section1,
    level: :bronze,
    description: "Use a try square to mark right angles accurately",
    position: 3
  },
  {
    section: section1,
    level: :bronze,
    description: "Mark centre points for drilling using a pencil",
    position: 4
  }
]

bronze_skills_s1.each do |skill_attrs|
  Skill.find_or_create_by!(
    section: skill_attrs[:section],
    description: skill_attrs[:description]
  ) do |skill|
    skill.level = skill_attrs[:level]
    skill.position = skill_attrs[:position]
  end
end

# Silver Skills
create_skill_if_needed(section1, :silver, "Use a marking gauge to mark parallel lines at a set distance", 1)
create_skill_if_needed(section1, :silver, "Mark out curves and circles using compasses or templates", 2)
create_skill_if_needed(section1, :silver, "Use a sliding bevel to mark and transfer angles", 3)
create_skill_if_needed(section1, :silver, "Select appropriate marking tools for different materials (scriber for metal/plastic)", 4)

# Gold Skills
create_skill_if_needed(section1, :gold, "Use a mortise gauge to mark multiple parallel lines accurately", 1)
create_skill_if_needed(section1, :gold, "Mark out complex shapes combining multiple measuring techniques", 2)
create_skill_if_needed(section1, :gold, "Check and verify measurements using different tools to ensure accuracy", 3)
create_skill_if_needed(section1, :gold, "Mark out components ensuring minimal material waste", 4)

puts "✅ Created Section: #{section1.name} with #{section1.skills.count} skills"

# SECTION 2: HAND TOOLS - CUTTING
section2 = Section.find_or_create_by!(name: "Hand Tools: Cutting") do |s|
  s.category = "Design and Construct"
  s.description = "Safe and accurate cutting is essential for creating quality projects."
  s.icon = "🪚"
  s.position = 2
end

# Bronze Skills
create_skill_if_needed(section2, :bronze, "Use a tenon saw safely to cut straight lines in softwood", 1)
create_skill_if_needed(section2, :bronze, "Start a cut correctly with controlled strokes", 2)
create_skill_if_needed(section2, :bronze, "Cut on the waste side of a marked line", 3)
create_skill_if_needed(section2, :bronze, "Use a bench hook correctly for safe cutting", 4)

# Silver Skills
create_skill_if_needed(section2, :silver, "Use a coping saw to cut curves in wood or plastic", 1)
create_skill_if_needed(section2, :silver, "Cut accurately to within 1mm of a marked line", 2)
create_skill_if_needed(section2, :silver, "Select the appropriate saw for different cuts (tenon, coping, hacksaw)", 3)
create_skill_if_needed(section2, :silver, "Use a hacksaw to cut metal safely and accurately", 4)

# Gold Skills
create_skill_if_needed(section2, :gold, "Cut joints (housing joints, halving joints) accurately by hand", 1)
create_skill_if_needed(section2, :gold, "Adjust cutting technique for different materials and thicknesses", 2)
create_skill_if_needed(section2, :gold, "Cut complex curves smoothly without breaking the blade", 3)
create_skill_if_needed(section2, :gold, "Demonstrate clean, accurate cuts requiring minimal finishing", 4)

puts "✅ Created Section: #{section2.name} with #{section2.skills.count} skills"

# SECTION 3: HAND TOOLS - SHAPING AND SMOOTHING
section3 = Section.find_or_create_by!(name: "Hand Tools: Shaping and Smoothing") do |s|
  s.category = "Design and Construct"
  s.description = "Shaping and smoothing skills transform rough materials into finished products."
  s.icon = "🔨"
  s.position = 3
end

# Bronze Skills
create_skill_if_needed(section3, :bronze, "Use a flat file to smooth edges of plastic or metal safely", 1)
create_skill_if_needed(section3, :bronze, "Hold and control a file with correct technique (push stroke only)", 2)
create_skill_if_needed(section3, :bronze, "Use sandpaper with a sanding block to smooth flat surfaces", 3)
create_skill_if_needed(section3, :bronze, "Progress through different grades of sandpaper (coarse to fine)", 4)

# Silver Skills
create_skill_if_needed(section3, :silver, "Use different file types for specific tasks (flat, round, half-round)", 1)
create_skill_if_needed(section3, :silver, "File metal accurately to a marked line", 2)
create_skill_if_needed(section3, :silver, "Use a Surform or rasp to shape wood quickly and safely", 3)
create_skill_if_needed(section3, :silver, "Use a smoothing plane to flatten and smooth wooden surfaces", 4)
create_skill_if_needed(section3, :silver, "Smooth curved surfaces using appropriate techniques and tools", 5)
create_skill_if_needed(section3, :silver, "Remove file marks and scratches using appropriate abrasives", 6)

# Gold Skills
create_skill_if_needed(section3, :gold, "Adjust plane blade depth and throat opening for different cutting depths", 1)
create_skill_if_needed(section3, :gold, "Use a spokeshave or block plane for curved or end grain work", 2)
create_skill_if_needed(section3, :gold, "Create chamfers and bevels using files or planes accurately", 3)
create_skill_if_needed(section3, :gold, "Achieve a smooth, professional finish requiring no further sanding", 4)
create_skill_if_needed(section3, :gold, "Select and justify the most appropriate shaping method for a given task", 5)

puts "✅ Created Section: #{section3.name} with #{section3.skills.count} skills"

# Add this to your seeds.rb after section3 (Shaping and Smoothing)

# SECTION 4: HAND TOOLS - JOINING
section4 = Section.find_or_create_by!(name: "Hand Tools: Joining") do |s|
  s.category = "Design and Construct"
  s.description = "Strong, accurate joints are crucial for durable projects."
  s.icon = "🔩"
  s.position = 4
end

# Bronze Skills
create_skill_if_needed(section4, :bronze, "Use a screwdriver correctly (matching driver to screw type)", 1)
create_skill_if_needed(section4, :bronze, "Drill pilot holes before inserting screws", 2)
create_skill_if_needed(section4, :bronze, "Apply PVA glue evenly and clamp joints correctly", 3)
create_skill_if_needed(section4, :bronze, "Use a hammer safely to drive panel pins", 4)

# Silver Skills
create_skill_if_needed(section4, :silver, "Countersink screw holes for flush finish", 1)
create_skill_if_needed(section4, :silver, "Select appropriate adhesive for different materials (PVA, contact adhesive, epoxy)", 2)
create_skill_if_needed(section4, :silver, "Use a nail punch to sink panel pins below the surface", 3)
create_skill_if_needed(section4, :silver, "Create simple joints using dowels", 4)
create_skill_if_needed(section4, :silver, "Use knock-down fittings (cam locks, barrel nuts) correctly", 5)

# Gold Skills
create_skill_if_needed(section4, :gold, "Use a chisel safely to cut housing or mortise joints", 1)
create_skill_if_needed(section4, :gold, "Select and justify joining methods based on material and purpose", 2)
create_skill_if_needed(section4, :gold, "Apply clamps with correct pressure and spacing for different joints", 3)
create_skill_if_needed(section4, :gold, "Create strong, accurate joints that meet quality standards", 4)

puts "✅ Created Section: #{section4.name} with #{section4.skills.count} skills"

# SECTION 5: HAND TOOLS - SAFETY AND MAINTENANCE
section5 = Section.find_or_create_by!(name: "Hand Tools: Safety and Maintenance") do |s|
  s.category = "Design and Construct"
  s.description = "Safe working practices and tool maintenance are essential in any workshop."
  s.icon = "🦺"
  s.position = 5
end

# Bronze Skills
create_skill_if_needed(section5, :bronze, "Identify and wear appropriate PPE (apron, goggles when required)", 1)
create_skill_if_needed(section5, :bronze, "Carry tools safely around the workshop", 2)
create_skill_if_needed(section5, :bronze, "Keep work area clean and organized", 3)
create_skill_if_needed(section5, :bronze, "Report damaged or unsafe tools to the teacher", 4)

# Silver Skills
create_skill_if_needed(section5, :silver, "Select appropriate PPE for different tasks", 1)
create_skill_if_needed(section5, :silver, "Store tools correctly after use", 2)
create_skill_if_needed(section5, :silver, "Perform basic tool maintenance (cleaning, checking for damage)", 3)
create_skill_if_needed(section5, :silver, "Work independently while following all safety procedures", 4)

# Gold Skills
create_skill_if_needed(section5, :gold, "Identify when tools need professional maintenance or replacement", 1)
create_skill_if_needed(section5, :gold, "Demonstrate workshop safety awareness and support others' safety", 2)
create_skill_if_needed(section5, :gold, "Maintain all tools in good working condition throughout a project", 3)
create_skill_if_needed(section5, :gold, "Conduct risk assessments for different workshop activities", 4)

puts "✅ Created Section: #{section5.name} with #{section5.skills.count} skills"

# SECTION 6: WORKSHOP PROCESSES - PILLAR DRILL
section6 = Section.find_or_create_by!(name: "Workshop Processes: Pillar Drill") do |s|
  s.category = "Design and Construct"
  s.description = "The pillar drill is essential for accurate hole drilling."
  s.icon = "🔧"
  s.position = 6
end

# Bronze Skills
create_skill_if_needed(section6, :bronze, "Identify the main parts of the pillar drill", 1)
create_skill_if_needed(section6, :bronze, "Use the pillar drill safely with supervision to drill holes", 2)
create_skill_if_needed(section6, :bronze, "Secure material correctly using a machine vice or clamp", 3)
create_skill_if_needed(section6, :bronze, "Wear appropriate PPE when using the pillar drill", 4)

# Silver Skills
create_skill_if_needed(section6, :silver, "Change drill bits safely and select appropriate sizes", 1)
create_skill_if_needed(section6, :silver, "Drill accurate holes in different materials (wood, plastic, metal)", 2)
create_skill_if_needed(section6, :silver, "Use a centre punch to mark drilling positions accurately", 3)
create_skill_if_needed(section6, :silver, "Control drilling depth using the depth stop", 4)

# Gold Skills
create_skill_if_needed(section6, :gold, "Adjust drill speed for different materials and bit sizes", 1)
create_skill_if_needed(section6, :gold, "Use specialist bits (forstner, countersink, hole saw) appropriately", 2)
create_skill_if_needed(section6, :gold, "Drill accurate holes for dowel joints or knock-down fittings", 3)
create_skill_if_needed(section6, :gold, "Operate the pillar drill independently with confidence", 4)

puts "✅ Created Section: #{section6.name} with #{section6.skills.count} skills"

# SECTION 7: WORKSHOP PROCESSES - SCROLL SAW
section7 = Section.find_or_create_by!(name: "Workshop Processes: Scroll Saw") do |s|
  s.category = "Design and Construct"
  s.description = "The scroll saw allows precise cutting of curves and intricate shapes."
  s.icon = "✂️"
  s.position = 7
end

# Bronze Skills
create_skill_if_needed(section7, :bronze, "Identify the main parts of the scroll saw", 1)
create_skill_if_needed(section7, :bronze, "Use the scroll saw safely with supervision", 2)
create_skill_if_needed(section7, :bronze, "Cut simple curves following a marked line", 3)
create_skill_if_needed(section7, :bronze, "Understand and follow safety procedures for the scroll saw", 4)

# Silver Skills
create_skill_if_needed(section7, :silver, "Cut complex curves and tight corners accurately", 1)
create_skill_if_needed(section7, :silver, "Create internal cuts by drilling access holes", 2)
create_skill_if_needed(section7, :silver, "Cut different materials (wood, plastic) with appropriate blade speeds", 3)
create_skill_if_needed(section7, :silver, "Feed material at appropriate speed to prevent blade breakage", 4)

# Gold Skills
create_skill_if_needed(section7, :gold, "Change and tension scroll saw blades correctly", 1)
create_skill_if_needed(section7, :gold, "Cut intricate patterns and detailed designs accurately", 2)
create_skill_if_needed(section7, :gold, "Select appropriate blade types for different materials and cut types", 3)
create_skill_if_needed(section7, :gold, "Operate the scroll saw independently to a high standard", 4)

puts "✅ Created Section: #{section7.name} with #{section7.skills.count} skills"

# SECTION 8: WORKSHOP PROCESSES - SANDERS
section8 = Section.find_or_create_by!(name: "Workshop Processes: Sanders") do |s|
  s.category = "Design and Construct"
  s.description = "Sanders help achieve smooth, professional finishes quickly."
  s.icon = "⚙️"
  s.position = 8
end

# Bronze Skills
create_skill_if_needed(section8, :bronze, "Identify belt and disc sanders and their uses", 1)
create_skill_if_needed(section8, :bronze, "Use the disc sander safely with supervision to smooth edges", 2)
create_skill_if_needed(section8, :bronze, "Keep work on the correct side of the disc (downward moving)", 3)
create_skill_if_needed(section8, :bronze, "Wear appropriate PPE and follow safety procedures", 4)

# Silver Skills
create_skill_if_needed(section8, :silver, "Use the belt sander to smooth flat surfaces", 1)
create_skill_if_needed(section8, :silver, "Sand edges and ends accurately using the disc sander", 2)
create_skill_if_needed(section8, :silver, "Use the sanding table and fence for accurate work", 3)
create_skill_if_needed(section8, :silver, "Avoid over-sanding and maintain accurate dimensions", 4)

# Gold Skills
create_skill_if_needed(section8, :gold, "Sand bevels and angles accurately using the tilting table", 1)
create_skill_if_needed(section8, :gold, "Achieve consistent, smooth finishes on different materials", 2)
create_skill_if_needed(section8, :gold, "Select appropriate sanding methods for different finishing requirements", 3)
create_skill_if_needed(section8, :gold, "Work independently with sanders to a professional standard", 4)

puts "✅ Created Section: #{section8.name} with #{section8.skills.count} skills"

# SECTION 9: WORKSHOP PROCESSES - VACUUM FORMING AND HEAT BENDING
section9 = Section.find_or_create_by!(name: "Workshop Processes: Vacuum Forming and Heat Bending") do |s|
  s.category = "Design and Construct"
  s.description = "Learn to shape plastic using heat for 3D forms."
  s.icon = "🔥"
  s.position = 9
end

# Bronze Skills
create_skill_if_needed(section9, :bronze, "Understand how thermoplastics can be shaped with heat", 1)
create_skill_if_needed(section9, :bronze, "Use the strip heater safely with supervision to bend acrylic", 2)
create_skill_if_needed(section9, :bronze, "Create simple right-angle bends in acrylic", 3)
create_skill_if_needed(section9, :bronze, "Follow safety procedures when working with heated plastic", 4)

# Silver Skills
create_skill_if_needed(section9, :silver, "Create accurate multiple bends in acrylic using the strip heater", 1)
create_skill_if_needed(section9, :silver, "Design and make a simple mould for vacuum forming", 2)
create_skill_if_needed(section9, :silver, "Assist with vacuum forming process under supervision", 3)
create_skill_if_needed(section9, :silver, "Understand mould design principles (draft angles, undercuts)", 4)

# Gold Skills
create_skill_if_needed(section9, :gold, "Create complex bent forms with accurate angles", 1)
create_skill_if_needed(section9, :gold, "Design and produce moulds that account for plastic thickness and draw", 2)
create_skill_if_needed(section9, :gold, "Operate vacuum former independently with teacher approval", 3)
create_skill_if_needed(section9, :gold, "Troubleshoot forming problems and adjust technique accordingly", 4)

puts "✅ Created Section: #{section9.name} with #{section9.skills.count} skills"

# Add this to your seeds.rb after section9 (Vacuum Forming)

# ============================================================================
# SECTION 2: MATERIALS
# ============================================================================

# SECTION 10: WOOD PROPERTIES
section10 = Section.find_or_create_by!(name: "Wood: Properties and Selection") do |s|
  s.category = "Materials"
  s.description = "Understanding wood properties helps you select the right material for your project."
  s.icon = "🌳"
  s.position = 10
end

# Bronze Skills
create_skill_if_needed(section10, :bronze, "Identify common types of wood (pine, oak, plywood, MDF)", 1)
create_skill_if_needed(section10, :bronze, "Understand the difference between softwood and hardwood", 2)
create_skill_if_needed(section10, :bronze, "Describe basic properties of wood (grain, texture, color)", 3)
create_skill_if_needed(section10, :bronze, "Select appropriate wood for a simple project", 4)

# Silver Skills
create_skill_if_needed(section10, :silver, "Explain properties like strength, workability, and durability", 1)
create_skill_if_needed(section10, :silver, "Understand manufactured boards (plywood, MDF, chipboard) and their uses", 2)
create_skill_if_needed(section10, :silver, "Compare advantages and disadvantages of different woods", 3)
create_skill_if_needed(section10, :silver, "Consider environmental impact when selecting wood", 4)

# Gold Skills
create_skill_if_needed(section10, :gold, "Analyze and justify wood selection based on functional requirements", 1)
create_skill_if_needed(section10, :gold, "Understand sustainability issues (FSC certification, deforestation)", 2)
create_skill_if_needed(section10, :gold, "Explain how wood properties affect manufacturing processes", 3)
create_skill_if_needed(section10, :gold, "Consider cost, availability, and aesthetics in material selection", 4)

puts "✅ Created Section: #{section10.name} with #{section10.skills.count} skills"

# SECTION 11: PLASTICS PROPERTIES
section11 = Section.find_or_create_by!(name: "Plastics and Acrylics: Properties and Selection") do |s|
  s.category = "Materials"
  s.description = "Plastics are versatile materials used in countless applications."
  s.icon = "🔷"
  s.position = 11
end

# Bronze Skills
create_skill_if_needed(section11, :bronze, "Identify common plastics (acrylic, polystyrene, PVC)", 1)
create_skill_if_needed(section11, :bronze, "Understand the difference between thermoplastics and thermosetting plastics", 2)
create_skill_if_needed(section11, :bronze, "Describe basic properties of plastics (flexibility, transparency, color)", 3)
create_skill_if_needed(section11, :bronze, "Select appropriate plastic for a simple project", 4)

# Silver Skills
create_skill_if_needed(section11, :silver, "Explain properties like impact resistance, chemical resistance, and formability", 1)
create_skill_if_needed(section11, :silver, "Understand how different plastics are formed (vacuum forming, injection molding)", 2)
create_skill_if_needed(section11, :silver, "Compare advantages and disadvantages of different plastics", 3)
create_skill_if_needed(section11, :silver, "Identify recycling symbols and understand plastic recycling", 4)

# Gold Skills
create_skill_if_needed(section11, :gold, "Analyze and justify plastic selection based on functional requirements", 1)
create_skill_if_needed(section11, :gold, "Understand environmental impact of plastics and alternatives", 2)
create_skill_if_needed(section11, :gold, "Explain how plastic properties affect manufacturing processes", 3)
create_skill_if_needed(section11, :gold, "Consider lifecycle, disposal, and circular economy in material selection", 4)

puts "✅ Created Section: #{section11.name} with #{section11.skills.count} skills"

# SECTION 12: METALS PROPERTIES
section12 = Section.find_or_create_by!(name: "Metals: Properties and Selection") do |s|
  s.category = "Materials"
  s.description = "Metals are strong, durable materials used in engineering and construction."
  s.icon = "⚙️"
  s.position = 12
end

# Bronze Skills
create_skill_if_needed(section12, :bronze, "Identify common metals (steel, aluminum, copper, brass)", 1)
create_skill_if_needed(section12, :bronze, "Understand the difference between ferrous and non-ferrous metals", 2)
create_skill_if_needed(section12, :bronze, "Describe basic properties of metals (strength, weight, appearance)", 3)
create_skill_if_needed(section12, :bronze, "Select appropriate metal for a simple project", 4)

# Silver Skills
create_skill_if_needed(section12, :silver, "Explain properties like tensile strength, hardness, ductility, and conductivity", 1)
create_skill_if_needed(section12, :silver, "Understand alloys and why they are used (steel, brass, bronze)", 2)
create_skill_if_needed(section12, :silver, "Compare advantages and disadvantages of different metals", 3)
create_skill_if_needed(section12, :silver, "Understand corrosion and methods of protection (painting, galvanizing)", 4)

# Gold Skills
create_skill_if_needed(section12, :gold, "Analyze and justify metal selection based on functional requirements", 1)
create_skill_if_needed(section12, :gold, "Understand sustainability issues (mining, recycling, embodied energy)", 2)
create_skill_if_needed(section12, :gold, "Explain how metal properties affect manufacturing processes", 3)
create_skill_if_needed(section12, :gold, "Consider cost, weight, and performance in material selection", 4)

puts "✅ Created Section: #{section12.name} with #{section12.skills.count} skills"

# SECTION 13: SUSTAINABILITY
section13 = Section.find_or_create_by!(name: "Sustainability and Material Selection") do |s|
  s.category = "Materials"
  s.description = "Understanding sustainability helps us make responsible choices about materials."
  s.icon = "♻️"
  s.position = 13
end

# Bronze Skills
create_skill_if_needed(section13, :bronze, "Understand the 3 Rs: Reduce, Reuse, Recycle", 1)
create_skill_if_needed(section13, :bronze, "Identify materials that can be recycled in projects", 2)
create_skill_if_needed(section13, :bronze, "Minimize waste when cutting and making products", 3)
create_skill_if_needed(section13, :bronze, "Understand basic environmental impact of materials", 4)

# Silver Skills
create_skill_if_needed(section13, :silver, "Understand lifecycle of products from raw materials to disposal", 1)
create_skill_if_needed(section13, :silver, "Compare environmental impact of different materials", 2)
create_skill_if_needed(section13, :silver, "Design products with end-of-life disposal in mind", 3)
create_skill_if_needed(section13, :silver, "Understand carbon footprint and embodied energy", 4)

# Gold Skills
create_skill_if_needed(section13, :gold, "Analyze products using lifecycle assessment principles", 1)
create_skill_if_needed(section13, :gold, "Understand circular economy and design for disassembly", 2)
create_skill_if_needed(section13, :gold, "Evaluate and justify material choices based on sustainability criteria", 3)
create_skill_if_needed(section13, :gold, "Consider social and economic factors alongside environmental impact", 4)

puts "✅ Created Section: #{section13.name} with #{section13.skills.count} skills"

# Add this to your seeds.rb after section13 (Sustainability)

# ============================================================================
# SECTION 3: GRAPHICS
# ============================================================================

# SECTION 14: MANUAL SKETCHING
section14 = Section.find_or_create_by!(name: "Manual Sketching and Rendering") do |s|
  s.category = "Graphics"
  s.description = "Sketching is essential for communicating design ideas quickly."
  s.icon = "✏️"
  s.position = 14
end

# Bronze Skills
create_skill_if_needed(section14, :bronze, "Use pencil to create simple sketches of products and ideas", 1)
create_skill_if_needed(section14, :bronze, "Add basic labels and notes to sketches", 2)
create_skill_if_needed(section14, :bronze, "Draw basic 3D shapes (cube, cylinder, sphere)", 3)
create_skill_if_needed(section14, :bronze, "Use different line weights to show importance", 4)

# Silver Skills
create_skill_if_needed(section14, :silver, "Sketch in perspective to show depth and form", 1)
create_skill_if_needed(section14, :silver, "Use rendering techniques (shading, color, tone) to enhance sketches", 2)
create_skill_if_needed(section14, :silver, "Add detail to show materials, textures, and finishes", 3)
create_skill_if_needed(section14, :silver, "Create multiple design ideas through rapid sketching", 4)

# Gold Skills
create_skill_if_needed(section14, :gold, "Produce high-quality presentation sketches with professional rendering", 1)
create_skill_if_needed(section14, :gold, "Use advanced rendering techniques (reflections, highlights, shadows)", 2)
create_skill_if_needed(section14, :gold, "Sketch complex forms and products accurately from different angles", 3)
create_skill_if_needed(section14, :gold, "Communicate design intent effectively through visual communication", 4)

puts "✅ Created Section: #{section14.name} with #{section14.skills.count} skills"

# SECTION 15: TECHNICAL DRAWING
section15 = Section.find_or_create_by!(name: "Technical Drawing") do |s|
  s.category = "Graphics"
  s.description = "Technical drawing uses precise standards to communicate exact dimensions and details."
  s.icon = "📐"
  s.position = 15
end

# Bronze Skills
create_skill_if_needed(section15, :bronze, "Use drawing equipment correctly (ruler, pencil, eraser)", 1)
create_skill_if_needed(section15, :bronze, "Draw straight lines and basic shapes accurately", 2)
create_skill_if_needed(section15, :bronze, "Add basic dimensions to drawings", 3)
create_skill_if_needed(section15, :bronze, "Understand difference between pictorial and orthographic views", 4)

# Silver Skills
create_skill_if_needed(section15, :silver, "Create orthographic projections (front, side, plan views)", 1)
create_skill_if_needed(section15, :silver, "Draw isometric projections of 3D objects", 2)
create_skill_if_needed(section15, :silver, "Apply correct dimensioning standards", 3)
create_skill_if_needed(section15, :silver, "Use different line types correctly (construction, outline, hidden detail)", 4)

# Gold Skills
create_skill_if_needed(section15, :gold, "Create working drawings with sectional views and details", 1)
create_skill_if_needed(section15, :gold, "Apply British Standards (BS8888) conventions correctly", 2)
create_skill_if_needed(section15, :gold, "Produce drawings accurate enough for manufacturing", 3)
create_skill_if_needed(section15, :gold, "Add tolerances, surface finishes, and material specifications", 4)

puts "✅ Created Section: #{section15.name} with #{section15.skills.count} skills"

# SECTION 16: CAD SOFTWARE
section16 = Section.find_or_create_by!(name: "CAD Software") do |s|
  s.category = "Graphics"
  s.description = "Computer-Aided Design allows precise 3D modeling and design."
  s.icon = "💻"
  s.position = 16
end

# Bronze Skills
create_skill_if_needed(section16, :bronze, "Navigate the CAD software interface and tools", 1)
create_skill_if_needed(section16, :bronze, "Create basic 2D shapes using drawing tools", 2)
create_skill_if_needed(section16, :bronze, "Create simple 3D forms using basic modeling tools", 3)
create_skill_if_needed(section16, :bronze, "Save, export, and organize CAD files", 4)

# Silver Skills
create_skill_if_needed(section16, :silver, "Use constraints and dimensions to create accurate models", 1)
create_skill_if_needed(section16, :silver, "Create more complex 3D models using extrude, revolve, and sweep", 2)
create_skill_if_needed(section16, :silver, "Apply materials, colors, and basic rendering to models", 3)
create_skill_if_needed(section16, :silver, "Create assembly models with multiple parts", 4)
create_skill_if_needed(section16, :silver, "Generate orthographic views from 3D models", 5)

# Gold Skills
create_skill_if_needed(section16, :gold, "Use advanced modeling techniques (loft, shell, pattern)", 1)
create_skill_if_needed(section16, :gold, "Create parametric models that can be easily modified", 2)
create_skill_if_needed(section16, :gold, "Prepare CAD files for manufacture (3D printing, laser cutting)", 3)
create_skill_if_needed(section16, :gold, "Create professional presentation renders and animations", 4)

puts "✅ Created Section: #{section16.name} with #{section16.skills.count} skills"

# SECTION 17: GRAPHIC DESIGN SOFTWARE
section17 = Section.find_or_create_by!(name: "Graphic Design Software") do |s|
  s.category = "Graphics"
  s.description = "Graphic design software creates visual communication for products and presentations."
  s.icon = "🎨"
  s.position = 17
end

# Bronze Skills
create_skill_if_needed(section17, :bronze, "Navigate graphic design software interface", 1)
create_skill_if_needed(section17, :bronze, "Use basic tools (selection, shapes, text, color)", 2)
create_skill_if_needed(section17, :bronze, "Import and place images in designs", 3)
create_skill_if_needed(section17, :bronze, "Create simple graphics for projects (logos, labels)", 4)

# Silver Skills
create_skill_if_needed(section17, :silver, "Use layers to organize complex designs", 1)
create_skill_if_needed(section17, :silver, "Apply design principles (alignment, contrast, hierarchy)", 2)
create_skill_if_needed(section17, :silver, "Edit and manipulate images (crop, resize, adjust)", 3)
create_skill_if_needed(section17, :silver, "Create graphics for different purposes (packaging, posters, presentations)", 4)
create_skill_if_needed(section17, :silver, "Export files in appropriate formats for different uses", 5)

# Gold Skills
create_skill_if_needed(section17, :gold, "Create professional, cohesive visual identities", 1)
create_skill_if_needed(section17, :gold, "Use advanced tools (pen tool, masks, effects)", 2)
create_skill_if_needed(section17, :gold, "Understand color theory and typography in design", 3)
create_skill_if_needed(section17, :gold, "Produce print-ready and web-ready graphics to professional standards", 4)

puts "✅ Created Section: #{section17.name} with #{section17.skills.count} skills"

# SECTION 18: LASER CUTTING
section18 = Section.find_or_create_by!(name: "Laser Cutting") do |s|
  s.category = "Graphics"
  s.description = "Laser cutting allows precise cutting and engraving of materials."
  s.icon = "⚡"
  s.position = 18
end

# Bronze Skills
create_skill_if_needed(section18, :bronze, "Understand how laser cutting works and what materials can be used", 1)
create_skill_if_needed(section18, :bronze, "Prepare simple 2D designs for laser cutting", 2)
create_skill_if_needed(section18, :bronze, "Understand difference between cutting and engraving", 3)
create_skill_if_needed(section18, :bronze, "Follow safety procedures when around laser cutter", 4)

# Silver Skills
create_skill_if_needed(section18, :silver, "Create designs with correct line weights for cutting vs engraving", 1)
create_skill_if_needed(section18, :silver, "Design parts that account for material thickness (kerf)", 2)
create_skill_if_needed(section18, :silver, "Optimize designs to minimize material waste", 3)
create_skill_if_needed(section18, :silver, "Assist with laser cutter operation under supervision", 4)

# Gold Skills
create_skill_if_needed(section18, :gold, "Create complex designs with multiple cutting and engraving operations", 1)
create_skill_if_needed(section18, :gold, "Design interlocking parts and assemblies for laser cutting", 2)
create_skill_if_needed(section18, :gold, "Operate laser cutter independently with teacher approval", 3)
create_skill_if_needed(section18, :gold, "Troubleshoot cutting problems and adjust settings accordingly", 4)

puts "✅ Created Section: #{section18.name} with #{section18.skills.count} skills"

# SECTION 19: 3D PRINTING
section19 = Section.find_or_create_by!(name: "3D Printing") do |s|
  s.category = "Graphics"
  s.description = "3D printing transforms digital designs into physical objects."
  s.icon = "🖨️"
  s.position = 19
end

# Bronze Skills
create_skill_if_needed(section19, :bronze, "Understand how 3D printing works and what it can make", 1)
create_skill_if_needed(section19, :bronze, "Prepare simple 3D models for printing", 2)
create_skill_if_needed(section19, :bronze, "Understand basic print settings (layer height, infill)", 3)
create_skill_if_needed(section19, :bronze, "Follow safety procedures when around 3D printers", 4)

# Silver Skills
create_skill_if_needed(section19, :silver, "Export 3D models in correct format (STL) with appropriate scale", 1)
create_skill_if_needed(section19, :silver, "Use slicing software to prepare models for printing", 2)
create_skill_if_needed(section19, :silver, "Design models that account for print orientation and supports", 3)
create_skill_if_needed(section19, :silver, "Assist with 3D printer operation and bed leveling under supervision", 4)

# Gold Skills
create_skill_if_needed(section19, :gold, "Design models optimized for 3D printing (wall thickness, overhangs)", 1)
create_skill_if_needed(section19, :gold, "Adjust advanced print settings for different materials and quality", 2)
create_skill_if_needed(section19, :gold, "Operate 3D printer independently with teacher approval", 3)
create_skill_if_needed(section19, :gold, "Troubleshoot print failures and perform basic printer maintenance", 4)

puts "✅ Created Section: #{section19.name} with #{section19.skills.count} skills"

puts "\n🎉 ALL SECTIONS COMPLETE!"
puts "📊 Complete Framework:"
puts "   Total Sections: #{Section.count}"
puts "   Total Skills: #{Skill.count}"
puts "   - Bronze: #{Skill.bronze.count}"
puts "   - Silver: #{Skill.silver.count}"
puts "   - Gold: #{Skill.gold.count}"
puts "\nBreakdown by Category:"
puts "   Design and Construct: #{Section.where(category: 'Design and Construct').count} sections"
puts "   Materials: #{Section.where(category: 'Materials').count} sections"
puts "   Graphics: #{Section.where(category: 'Graphics').count} sections"

puts "\n🎉 Seeding complete!"
puts "📊 Summary:"
puts "   Sections: #{Section.count}"
puts "   Skills: #{Skill.count}"
puts "   - Bronze: #{Skill.bronze.count}"
puts "   - Silver: #{Skill.silver.count}"
puts "   - Gold: #{Skill.gold.count}"

puts "\n👤 Creating demo teacher account..."
demo_teacher = User.find_or_initialize_by(email: "teacher@demo.com")
demo_teacher.assign_attributes(
  password: "password123",
  password_confirmation: "password123",
  name: "Peter MacLeod",
  school: "Demo High School, Bute"
)
demo_teacher.save!
puts "✅ Created/Updated demo teacher: #{demo_teacher.name} (#{demo_teacher.email})"

puts "\n🏫 Creating demo classrooms..."
classroom1 = Classroom.find_or_create_by!(user: demo_teacher, name: "S1 Technologies A") do |c|
  c.year_group = "S1"
end

classroom2 = Classroom.find_or_create_by!(user: demo_teacher, name: "S2 Technologies B") do |c|
  c.year_group = "S2"
end
puts "✅ Created classrooms: #{classroom1.full_name} and #{classroom2.full_name}"

puts "\n👨‍🎓 Creating students..."

# Scottish first and last names
scottish_first_names = ["Fraser", "Cameron", "Ewan", "Lachlan", "Angus", "Callum", "Rory", "Hamish", "Finlay", "Alistair", "Isla", "Eilidh", "Skye", "Ailsa", "Morag"]
scottish_last_names = ["MacLeod", "Campbell", "MacDonald", "Stewart", "Fraser", "Murray", "MacKenzie", "MacGregor", "MacLean", "MacPherson", "Robertson", "Anderson", "Ross", "Graham", "Sinclair"]

# Create students for classroom 1 (S1)
s1_students = []
6.times do |i|
  first_name = scottish_first_names.sample
  last_name = scottish_last_names.sample
  student = Student.find_or_create_by!(
    classroom: classroom1,
    first_name: first_name,
    last_name: last_name
  )
  s1_students << student
end
puts "✅ Created #{s1_students.count} students for #{classroom1.full_name}"

# Create students for classroom 2 (S2)
s2_students = []
5.times do |i|
  first_name = scottish_first_names.sample
  last_name = scottish_last_names.sample
  student = Student.find_or_create_by!(
    classroom: classroom2,
    first_name: first_name,
    last_name: last_name
  )
  s2_students << student
end
puts "✅ Created #{s2_students.count} students for #{classroom2.full_name}"

puts "\n📝 Marking skills as demonstrated..."

# Get all sections and skills
all_sections = Section.all
all_skills = Skill.all

# Helper method to mark skills for a student
def mark_skills_for_student(student, section, level, percentage)
  skills = section.skills.where(level: level).ordered
  count_to_mark = (skills.count * percentage / 100.0).ceil
  
  skills.take(count_to_mark).each do |skill|
    student_skill = StudentSkill.find_or_create_by!(
      student: student,
      skill: skill
    )
    unless student_skill.demonstrated?
      student_skill.update!(
        demonstrated: true,
        demonstrated_at: rand(14..30).days.ago
      )
    end
  end
end

# Student 1 (S1): Close to earning bronze badge (75%+ bronze skills)
student1 = s1_students[0]
section1 = all_sections.first
mark_skills_for_student(student1, section1, :bronze, 100) # All bronze
mark_skills_for_student(student1, section1, :silver, 50) # Half silver
mark_skills_for_student(student1, section1, :gold, 25) # Quarter gold
puts "✅ #{student1.full_name}: Close to bronze badge (100% bronze, 50% silver, 25% gold in first section)"

# Student 2 (S1): Already has bronze badge, working on silver
student2 = s1_students[1]
mark_skills_for_student(student2, section1, :bronze, 100) # All bronze
mark_skills_for_student(student2, section1, :silver, 75) # 75% silver
mark_skills_for_student(student2, section1, :gold, 25) # Some gold
# Award bronze badge
if student2.ready_for_badge?(section1, :bronze) && !student2.has_badge?(section1, :bronze)
  Badge.create!(
    student: student2,
    section: section1,
    level: :bronze,
    awarded_by: demo_teacher,
    awarded_at: 10.days.ago
  )
end
puts "✅ #{student2.full_name}: Has bronze badge, working on silver (100% bronze, 75% silver)"

# Student 3 (S1): Has bronze AND silver badges
student3 = s1_students[2]
mark_skills_for_student(student3, section1, :bronze, 100) # All bronze
mark_skills_for_student(student3, section1, :silver, 100) # All silver
mark_skills_for_student(student3, section1, :gold, 50) # Half gold
# Award bronze and silver badges
if student3.ready_for_badge?(section1, :bronze) && !student3.has_badge?(section1, :bronze)
  Badge.create!(
    student: student3,
    section: section1,
    level: :bronze,
    awarded_by: demo_teacher,
    awarded_at: 15.days.ago
  )
end
if student3.ready_for_badge?(section1, :silver) && !student3.has_badge?(section1, :silver)
  Badge.create!(
    student: student3,
    section: section1,
    level: :silver,
    awarded_by: demo_teacher,
    awarded_at: 8.days.ago
  )
end
puts "✅ #{student3.full_name}: Has bronze and silver badges (100% bronze, 100% silver, 50% gold)"

# Student 4 (S1): Just a few skills demonstrated
student4 = s1_students[3]
mark_skills_for_student(student4, section1, :bronze, 50) # Half bronze
mark_skills_for_student(student4, section1, :silver, 25) # Quarter silver
puts "✅ #{student4.full_name}: Just starting (50% bronze, 25% silver)"

# Student 5 (S1): Moderate progress
student5 = s1_students[4]
mark_skills_for_student(student5, section1, :bronze, 75) # 75% bronze
mark_skills_for_student(student5, section1, :silver, 25) # Some silver
puts "✅ #{student5.full_name}: Moderate progress (75% bronze, 25% silver)"

# Student 6 (S1): Good progress, multiple sections
student6 = s1_students[5]
section2 = all_sections.second
mark_skills_for_student(student6, section1, :bronze, 100) # All bronze in section 1
mark_skills_for_student(student6, section1, :silver, 50) # Half silver in section 1
mark_skills_for_student(student6, section2, :bronze, 75) # 75% bronze in section 2
# Award bronze badge for section 1
if student6.ready_for_badge?(section1, :bronze) && !student6.has_badge?(section1, :bronze)
  Badge.create!(
    student: student6,
    section: section1,
    level: :bronze,
    awarded_by: demo_teacher,
    awarded_at: 12.days.ago
  )
end
puts "✅ #{student6.full_name}: Good progress across sections (bronze badge in section 1)"

# S2 Students - varied progress
# Student 7 (S2): Close to bronze
student7 = s2_students[0]
mark_skills_for_student(student7, section1, :bronze, 100) # All bronze
mark_skills_for_student(student7, section1, :silver, 50) # Half silver
puts "✅ #{student7.full_name}: Close to bronze badge (100% bronze, 50% silver)"

# Student 8 (S2): Has bronze, working on silver
student8 = s2_students[1]
mark_skills_for_student(student8, section1, :bronze, 100)
mark_skills_for_student(student8, section1, :silver, 75)
mark_skills_for_student(student8, section2, :bronze, 50)
if student8.ready_for_badge?(section1, :bronze) && !student8.has_badge?(section1, :bronze)
  Badge.create!(
    student: student8,
    section: section1,
    level: :bronze,
    awarded_by: demo_teacher,
    awarded_at: 9.days.ago
  )
end
puts "✅ #{student8.full_name}: Has bronze badge, working on silver"

# Student 9 (S2): Has bronze and silver
student9 = s2_students[2]
mark_skills_for_student(student9, section1, :bronze, 100)
mark_skills_for_student(student9, section1, :silver, 100)
mark_skills_for_student(student9, section1, :gold, 25)
if student9.ready_for_badge?(section1, :bronze) && !student9.has_badge?(section1, :bronze)
  Badge.create!(
    student: student9,
    section: section1,
    level: :bronze,
    awarded_by: demo_teacher,
    awarded_at: 14.days.ago
  )
end
if student9.ready_for_badge?(section1, :silver) && !student9.has_badge?(section1, :silver)
  Badge.create!(
    student: student9,
    section: section1,
    level: :silver,
    awarded_by: demo_teacher,
    awarded_at: 6.days.ago
  )
end
puts "✅ #{student9.full_name}: Has bronze and silver badges"

# Student 10 (S2): Just a few skills
student10 = s2_students[3]
mark_skills_for_student(student10, section1, :bronze, 25) # Just started
puts "✅ #{student10.full_name}: Just starting (25% bronze)"

# Student 11 (S2): Moderate progress
student11 = s2_students[4]
mark_skills_for_student(student11, section1, :bronze, 75)
mark_skills_for_student(student11, section2, :bronze, 50)
puts "✅ #{student11.full_name}: Moderate progress across sections"

puts "\n🎉 Demo data seeding complete!"
puts "📊 Final Summary:"
puts "   Users: #{User.count}"
puts "   Classrooms: #{Classroom.count}"
puts "   Students: #{Student.count}"
puts "   Student Skills: #{StudentSkill.count}"
puts "   Demonstrated Skills: #{StudentSkill.where(demonstrated: true).count}"
puts "   Badges: #{Badge.count}"
puts "\n🔑 Demo Login:"
puts "   Email: teacher@demo.com"
puts "   Password: password123"