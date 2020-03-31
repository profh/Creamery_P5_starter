module Contexts
  module ShiftJobs

    def create_shift_jobs
      @sj_ralph_cashier = FactoryBot.create(:shift_job, shift: @shift_ralph_1, job: @cashier)
      @sj_ralph_cashier2 = FactoryBot.create(:shift_job, shift: @shift_ralph_2, job: @cashier)
      @sj_ralph_mopping = FactoryBot.create(:shift_job, shift: @shift_ralph_2, job: @mopping)

    end
    
    def destroy_shift_jobs
      @sj_ralph_cashier.destroy
      @sj_ralph_cashier2.destroy
      @sj_ralph_mopping.destroy
    end

  end
end