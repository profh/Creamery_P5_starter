module Contexts
  module Jobs

    def create_jobs
      @cashier = FactoryBot.create(:job)
      @mopping = FactoryBot.create(:job, name: "Mopping", description: "Mopping floor")
      @making = FactoryBot.create(:job, name: "Ice cream making", description: "Making ice cream")
      @mover = FactoryBot.create(:job, name: "Mover", active: false, description: "Moving stuff")
    end
    
    def destroy_jobs
      @cashier.destroy
      @mopping.destroy
      @making.destroy
      @mover.destroy
    end

  end
end