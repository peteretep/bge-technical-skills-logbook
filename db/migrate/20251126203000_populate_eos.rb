class PopulateEos < ActiveRecord::Migration[7.2]
  def up
    puts "Syncing Skills..."
    Skill.find_each do |skill|
      skill.save!
      print "."
    end
    puts "\nSyncing Sections..."
    Section.find_each do |section|
      section.save!
      print "."
    end
    puts "\nDone!"
  end

  def down
    # No-op
  end
end
