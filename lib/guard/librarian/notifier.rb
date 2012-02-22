# encoding: utf-8
module Guard
  class Librarian
    class Notifier

      def self.guard_message(result, duration)
        case result
        when 'up-to-date'
          "Cookbooks already up-to-date"
        when true
          "Cookbooks have been updated\nin %.1f seconds." % [duration]
        else
          "Cookbooks can't be updated,\nplease check manually."
        end
      end

      # failed | success
      def self.guard_image(result)
        icon = if result
          :success
        else
          :failed
        end
      end

      def self.notify(result, duration)
        message = guard_message(result, duration)
        image   = guard_image(result)

        ::Guard::Notifier.notify(message, :title => 'Cookbooks updated', :image => image)
      end

    end
  end
end
